class Api::V1::LoyaltyTiersController < ApplicationController
  before_action :authenticate_admin_or_kasir

  def index
    render json: LoyaltyTier.order(min_points: :asc)
  end

  def create
    @tier = LoyaltyTier.new(tier_params)
    if @tier.save
      render json: @tier, status: :created
    else
      render json: @tier.errors, status: :unprocessable_entity
    end
  end

  def update
    @tier = LoyaltyTier.find(params[:id])
    if @tier.update(tier_params)
      render json: @tier
    else
      render json: @tier.errors, status: :unprocessable_entity
    end
  end

  private

  def tier_params
    params.require(:loyalty_tier).permit(:name, :min_points, :discount_percent)
  end
end
