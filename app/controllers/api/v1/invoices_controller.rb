class Api::V1::InvoicesController < ApplicationController
  before_action :authenticate_admin_or_kasir

  # GET /api/v1/invoices/:transaksi_id — generate tax invoice for a transaction
  def show
    @transaksi = Transaksi.find(params[:id])
    subtotal = @transaksi.total_harga.to_f
    ppn_rate = 0.11 # PPN 11% (Indonesia)
    ppn_amount = (subtotal * ppn_rate).round(2)
    grand_total = subtotal + ppn_amount

    render json: {
      invoice_number: "INV-#{@transaksi.id}-#{@transaksi.created_at.strftime('%Y%m%d')}",
      transaction_id: @transaksi.id,
      created_at: @transaksi.created_at,
      customer_name: @transaksi.customer_phone,
      customer_phone: @transaksi.customer_phone,
      subtotal: subtotal,
      ppn_rate: ppn_rate,
      ppn_amount: ppn_amount,
      grand_total: grand_total,
      status: @transaksi.status
    }
  end
end
