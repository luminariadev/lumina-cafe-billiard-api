class TransactionService
  Result = Struct.new(:success, :transaction, :error, keyword_init: true) do
    def success?
      success
    end
  end

  def initialize(user:, payment_method:, items:)
    @user = user
    @payment_method = payment_method
    @items = normalize_items(items)
  end

  def call
    return failure("Pilih minimal satu produk.") if @items.empty?

    transaction = nil
    ActiveRecord::Base.transaction do
      products = Product.lock.where(id: @items.keys).index_by(&:id)
      validate_stock!(products)

      transaction = Transaksi.create!(
        user: @user,
        transaksi_type: :cafe,
        payment_method: @payment_method,
        total_amount: 0,
        status: :pending,
        jam_mulai: Time.current
      )

      total = create_items!(transaction, products)
      transaction.update!(total_amount: total)
    end

    Result.new(success: true, transaction: transaction)
  rescue ActiveRecord::RecordInvalid, ArgumentError => e
    failure(e.message)
  end

  private

  def normalize_items(raw)
    result = {}
    raw.each do |product_id, quantity|
      pid = product_id.to_i
      qty = quantity.to_i
      result[pid] = qty if pid.positive? && qty.positive?
    end
    result
  end

  def validate_stock!(products)
    @items.each do |product_id, quantity|
      product = products[product_id.to_i]
      raise ArgumentError, "Produk tidak ditemukan." unless product
      raise ArgumentError, "#{product.name} stok #{product.stock}, kurang dari #{quantity}." if product.stock < quantity
    end
  end

  def create_items!(transaction, products)
    @items.sum do |product_id, quantity|
      product = products[product_id.to_i]
      price = product.price.to_d
      subtotal = price * quantity

      TransaksiItem.create!(
        transaksi: transaction,
        product: product,
        quantity: quantity,
        price: price,
        subtotal: subtotal
      )

      product.update!(stock: product.stock - quantity)
      subtotal
    end
  end

  def failure(message)
    Result.new(success: false, error: message)
  end
end