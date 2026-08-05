class Api::V1::GuestOrdersController < ApplicationController
  skip_before_action :authorize_request, only: [:menu, :create, :status]

  # GET /api/v1/guest_orders/menu?branch_id=X — public menu (no auth)
  def menu
    @products = Product
      .where(status: :active)
      .where("stock > 0 OR product_type != ?", 0) # exclude out-of-stock billiard; show cafe items
      .includes(:category)

    render json: @products.map { |p|
      {
        id: p.id,
        name: p.name,
        price: p.price.to_f,
        category: p.category&.name,
        product_type: p.product_type,
        stock: p.stock
      }
    }
  end

  # POST /api/v1/guest_orders — create order from guest phone (QR self-order)
  # params: { branch_id, meja_id, customer_phone, customer_name, items: [{product_id, quantity}] }
  def create
    items = params[:items] || []
    return render json: { error: 'Items tidak boleh kosong' }, status: :unprocessable_entity if items.empty?

    total = 0
    @transaksi = Transaksi.new(
      transaksi_type: :cafe,
      status: :pending,
      payment_method: :tunai,
      customer_phone: params[:customer_phone],
      meja_id: params[:meja_id],
      jam_mulai: Time.current
    )

    items.each do |item|
      product = Product.find(item[:product_id])
      qty = item[:quantity].to_i
      subtotal = product.price * qty
      total += subtotal
      @transaksi.transaksi_items.build(
        product: product,
        quantity: qty,
        price: product.price,
        subtotal: subtotal
      )
    end

    @transaksi.total_amount = total

    if @transaksi.save
      OrdersChannel.broadcast_new_order(@transaksi, params[:branch_id] || 1)
      render json: {
        id: @transaksi.id,
        kode_transaksi: @transaksi.kode_transaksi,
        status: @transaksi.status,
        total: total,
        items: items.size,
        message: 'Pesanan diterima!'
      }, status: :created
    else
      render json: @transaksi.errors, status: :unprocessable_entity
    end
  end

  # GET /api/v1/guest_orders/status?phone=X — guest checks order status (no auth)
  def status
    @orders = Transaksi
      .where(customer_phone: params[:phone])
      .order(jam_mulai: :desc)
      .limit(10)

    render json: @orders.as_json(
      only: [:id, :kode_transaksi, :status, :payment_method, :total_amount, :jam_mulai],
      include: { transaksi_items: { include: { product: { only: [:id, :name] } } } }
    )
  end
end
