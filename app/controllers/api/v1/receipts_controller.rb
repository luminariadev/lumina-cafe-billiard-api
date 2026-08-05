class Api::V1::ReceiptsController < ApplicationController
  before_action :authorize_admin_or_kasir

  # GET /api/v1/receipts/:transaksi_id — formatted receipt data for thermal printer
  def show
    @transaksi = Transaksi.find(params[:id])
    @items = @transaksi.transaksi_items.includes(:product)

    render json: {
      header: {
        business_name: 'Lumina Cafe & Billiard',
        address: 'Jl. Contoh No. 123, Bandung',
        phone: '0812-3456-7890'
      },
      transaction: {
        id: @transaksi.id,
        kode: @transaksi.kode_transaksi,
        date: @transaksi.created_at,
        cashier: @transaksi.user&.username || '-'
      },
      items: @items.map do |ti|
        {
          name: ti.product&.name || "Item ##{ti.product_id}",
          qty: ti.quantity,
          price: ti.price.to_f,
          subtotal: ti.subtotal.to_f
        }
      end,
      payment: {
        method: @transaksi.payment_method,
        total: @transaksi.total_amount.to_f
      },
      footer: {
        thank_you_message: 'Terima kasih atas kunjungan Anda!',
        generated_at: Time.current
      }
    }
  end
end
