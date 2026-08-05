class Api::V1::OrdersChannelController < ApplicationController
  before_action :authorize_admin_or_kasir

  # GET /api/v1/orders/pending?branch_id=X
  def index
    @orders = Transaksi
      .where(status: %w[pending dibayar])
      .where("jam_mulai >= ?", 24.hours.ago)
      .includes(:transaksi_items, :meja, :user)
      .order(jam_mulai: :desc)

    render json: @orders.as_json(
      include: {
        transaksi_items: { include: { product: { only: [:id, :name] } } },
        meja: { only: [:id, :no_meja, :nama] },
        user: { only: [:id, :username] }
      }
    )
  end

  # GET /api/v1/orders/latest?branch_id=X&since=ISO_TIMESTAMP
  def latest
    since = params[:since].present? ? Time.parse(params[:since]) : 1.minute.ago
    @orders = Transaksi
      .where("jam_mulai > ?", since)
      .order(jam_mulai: :desc)
      .limit(20)

    render json: @orders.as_json(include: :transaksi_items)
  end

  # PATCH /api/v1/orders/:id/status  { status: "preparing"|"ready"|"completed" }
  def update_status
    @order = Transaksi.find(params[:id])
    new_status = params[:status]

    unless %w[pending dibayar preparing ready completed batal].include?(new_status)
      return render json: { error: "Status tidak valid" }, status: :unprocessable_entity
    end

    if @order.update(status: new_status)
      OrdersChannel.broadcast_status_update(@order, @order.meja&.branch_id || 1)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end
end
