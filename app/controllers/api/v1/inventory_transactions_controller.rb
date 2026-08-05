class Api::V1::InventoryTransactionsController < ApplicationController
  before_action :authenticate_admin_or_kasir

  def index
    @transactions = InventoryTransaction.all.order(created_at: :desc)
    render json: @transactions
  end

  def create
    @transaction = InventoryTransaction.new(transaction_params)
    if @transaction.save
      render json: @transaction, status: :created
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:inventory_transaction).permit(:item_id, :user_id, :transaction_type, :quantity, :notes)
  end
end
