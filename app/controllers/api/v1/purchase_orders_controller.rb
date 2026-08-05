class Api::V1::PurchaseOrdersController < ApplicationController
  before_action :authenticate_admin_or_kasir
  before_action :set_purchase_order, only: [:show, :update, :destroy]

  def index
    @purchase_orders = PurchaseOrder.all.order(order_date: :desc)
    render json: @purchase_orders
  end

  def show
    render json: @purchase_order
  end

  def create
    @purchase_order = PurchaseOrder.new(purchase_order_params)
    if @purchase_order.save
      render json: @purchase_order, status: :created
    else
      render json: @purchase_order.errors, status: :unprocessable_entity
    end
  end

  def update
    if @purchase_order.update(purchase_order_params)
      render json: @purchase_order
    else
      render json: @purchase_order.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @purchase_order.destroy
    head :no_content
  end

  private

  def set_purchase_order
    @purchase_order = PurchaseOrder.find(params[:id])
  end

  def purchase_order_params
    params.require(:purchase_order).permit(:supplier_id, :item_id, :quantity, :price_per_unit, :status, :notes, :order_date, :received_date)
  end
end
