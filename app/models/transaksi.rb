class Transaksi < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :meja, optional: true
  has_many :transaksi_items, dependent: :destroy
  accepts_nested_attributes_for :transaksi_items
  enum :transaksi_type, { billiard: 0, cafe: 1 }
  enum :status, { pending: 0, dibayar: 1, batal: 2 }
  enum :payment_method, { tunai: 0, transfer: 1, qris: 2, debit: 3, kredit: 4 }
  validates :kode_transaksi, presence: true, uniqueness: true
  before_validation :generate_kode_transaksi, on: :create
  after_create :deduct_stocks

  scope :today, -> { where("DATE(jam_mulai) = ?", Time.zone.today) }
  scope :this_month, -> { where("jam_mulai >= ?", Time.zone.today.beginning_of_month) }
  scope :between_dates, ->(start_date, end_date) { where(jam_mulai: start_date..end_date) }

  def generate_kode_transaksi
    return if kode_transaksi
    prefix = billiard? ? "GB" : "GC"
    date_part = Time.current.strftime("%Y%m%d")
    seq = (self.class.where("kode_transaksi LIKE ?", "#{prefix}#{date_part}%").count + 1).to_s.rjust(4, "0")
    self.kode_transaksi = "#{prefix}#{date_part}#{seq}"
  end

  def generate_qris
    self.qris_string = "LUMINA-#{kode_transaksi}-#{SecureRandom.hex(6)}"
    self.qr_expires_at = Time.current + 5.minutes
  end

  private

  # Auto-deduct product stock when a cafe/billiard transaction is created.
  def deduct_stocks
    return if batal?

    transaksi_items.each do |ti|
      product = ti.product
      next unless product&.stock.present?

      begin
        product.deduct_stock(ti.quantity)
      rescue StandardError => e
        Rails.logger.warn "[transaksi:#{id}] stock deduction failed for product #{product.id}: #{e.message}"
      end
    end
  end
end
