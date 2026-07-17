class Transaksi < ApplicationRecord
  belongs_to :user
  belongs_to :meja, optional: true
  has_many :transaksi_items, dependent: :destroy
  accepts_nested_attributes_for :transaksi_items
  enum :transaksi_type, { billiard: 0, cafe: 1 }
  enum :status, { pending: 0, dibayar: 1, batal: 2 }
  enum :payment_method, { tunai: 0, transfer: 1, qris: 2, debit: 3, kredit: 4 }
  validates :kode_transaksi, presence: true, uniqueness: true
  before_validation :generate_kode_transaksi, on: :create

  private
  def generate_kode_transaksi
    return if kode_transaksi
    prefix = billiard? ? "BL" : "CF"
    date_part = Time.current.strftime("%y%m%d")
    seq = (self.class.where("kode_transaksi LIKE ?", "#{prefix}#{date_part}%").count + 1).to_s.rjust(4, "0")
    self.kode_transaksi = "#{prefix}#{date_part}#{seq}"
  end
end
