class Api::V1::LoyaltyController < ApplicationController
  before_action :authenticate_admin_or_kasir

  # GET /api/v1/loyalty/points?phone=0812...
  def points
    @loyalty = LoyaltyPoint.find_by(phone: params[:phone])
    if @loyalty
      render json: @loyalty.as_json(include: :loyalty_point_transactions)
    else
      render json: { phone: params[:phone], points: 0 }, status: :ok
    end
  end

  # GET /api/v1/loyalty/tiers
  def tiers
    render json: LoyaltyTier.order(min_points: :asc)
  end

  # POST /api/v1/loyalty/earn  { transaksi_id, points, notes }
  def earn
    @transaksi = Transaksi.find(params[:transaksi_id])
    @txn = LoyaltyPointTransaction.new(
      user_id: current_user.id,
      transaksi_id: @transaksi.id,
      points: params[:points],
      action: 'earn',
      notes: params[:notes]
    )
    if @txn.save
      render json: @txn, status: :created
    else
      render json: @txn.errors, status: :unprocessable_entity
    end
  end

  # POST /api/v1/loyalty/redeem  { transaksi_id, points, notes }
  def redeem
    @transaksi = Transaksi.find(params[:transaksi_id])
    phone = @transaksi.customer_phone
    @loyalty = LoyaltyPoint.find_by(phone: phone)

    if @loyalty.nil? || @loyalty.points < params[:points].to_i
      return render json: { error: 'Saldo poin tidak cukup' }, status: :unprocessable_entity
    end

    @txn = LoyaltyPointTransaction.new(
      user_id: current_user.id,
      transaksi_id: @transaksi.id,
      points: params[:points],
      action: 'redeem',
      notes: params[:notes]
    )
    if @txn.save
      render json: @txn, status: :created
    else
      render json: @txn.errors, status: :unprocessable_entity
    end
  end
end
