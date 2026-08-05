class PaymentGatewayService
  # Production-ready structure for Midtrans/Xendit integration.
  # Mock implementations — replace with real API calls when keys are set.

  attr_reader :transaksi

  def initialize(transaksi)
    @transaksi = transaksi
  end

  # Generate QRIS payment payload (string + expiry)
  def process_qris
    {
      qris_string: "LUMINA-QR-#{transaksi.kode_transaksi}-#{SecureRandom.hex(6)}",
      expires_at: Time.current + 5.minutes,
      amount: transaksi.total_amount.to_f,
      method: 'qris'
    }
  end

  # Virtual Account transfer payload
  def process_transfer(bank_code = 'bca')
    {
      va_number: "8808#{transaksi.id.to_s.rjust(10, '0')}",
      bank_code: bank_code,
      amount: transaksi.total_amount.to_f,
      expires_at: Time.current + 24.hours,
      method: 'transfer'
    }
  end

  # Card payment (debit/kredit) — mock processor
  def process_card(card_type = :debit)
    {
      card_authorization: "AUTH-#{SecureRandom.hex(8)}",
      card_type: card_type,
      amount: transaksi.total_amount.to_f,
      status: 'approved',
      method: card_type.to_s
    }
  end

  # Verify a payment — mock: always returns paid for paid transactions
  def verify_payment
    {
      verified: transaksi.status == 'dibayar',
      transaction_id: transaksi.id,
      payment_method: transaksi.payment_method,
      paid_at: transaksi.updated_at
    }
  end

  # Live API integration point — implement when PAYMENT_API_KEY is present
  def self.live?
    ENV['PAYMENT_API_KEY'].present? && ENV['PAYMENT_MERCHANT_ID'].present?
  end
end
