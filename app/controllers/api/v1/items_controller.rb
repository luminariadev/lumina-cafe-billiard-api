class Api::V1::ItemsController < ApplicationController
  before_action :authenticate_admin_or_kasir
  before_action :set_item, only: [:show, :update, :destroy]

  def index
    @items = Item.all
    render json: @items.as_json(include: :inventory_transactions)
  end

  def show
    render json: @item.as_json(include: :inventory_transactions)
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      render json: @item, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    head :no_content
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :unit, :stock, :min_stock_alert)
  end
end
