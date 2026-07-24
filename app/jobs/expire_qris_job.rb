class ExpireQrisJob < ApplicationJob
  queue_as :default

  def perform(*args)
    expired = Transaksi.where(status: :pending)
      .where("qr_expires_at IS NOT NULL AND qr_expires_at < ?", Time.current)
      .update_all(status: :batal, jam_selesai: Time.current)

    Rails.logger.info "[ExpireQrisJob] Expired #{expired} pending transaksi dengan QRIS kadaluarsa"
  end
end
