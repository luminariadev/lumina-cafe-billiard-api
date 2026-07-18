module Api
  module V1
    class GuestTransactionsController < ApplicationController
      skip_before_action :authorize_request

      def billiard_booking
        meja = Meja.find_by(nomor_meja: params[:nomor_meja], status: :tersedia)
        return render json: { error: "Meja tidak tersedia" }, status: :unprocessable_entity unless meja

        durasi = (params[:durasi_jam] || 1).to_i
        price_per_hour = 25_000
        total = durasi * price_per_hour

        transaksi = Transaksi.new(
          meja: meja,
          customer_name: params[:customer_name],
          customer_phone: params[:customer_phone],
          transaksi_type: :billiard,
          status: :pending,
          total_amount: total,
          jam_mulai: Time.current,
          payment_method: :qris
        )
        transaksi.generate_kode_transaksi
        transaksi.generate_qris

        if transaksi.save
          meja.update!(status: :terpakai)
          render json: {
            kode_transaksi: transaksi.kode_transaksi,
            total_amount: transaksi.total_amount,
            qris_string: transaksi.qris_string,
            qr_expires_at: transaksi.qr_expires_at,
            id: transaksi.id,
            status: transaksi.status
          }, status: :created
        else
          render json: { errors: transaksi.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def cafe_order
        items = params[:items] || {}
        payment_method = params[:payment_method] || "qris"

        return render json: { error: "Items tidak boleh kosong" }, status: :unprocessable_entity if items.empty?

        transaksi = Transaksi.new(
          customer_name: params[:customer_name],
          customer_phone: params[:customer_phone],
          transaksi_type: :cafe,
          status: :pending,
          payment_method: payment_method,
          jam_mulai: Time.current
        )
        transaksi.generate_kode_transaksi
        transaksi.generate_qris if payment_method == "qris"

        total = 0
        items.each do |product_id, qty|
          product = Product.find_by(id: product_id)
          next unless product
          qty = qty.to_i
          next if qty <= 0
          transaksi.transaksi_items.build(
            product_id: product.id,
            quantity: qty,
            price: product.price,
            subtotal: product.price * qty
          )
          total += product.price * qty
        end

        return render json: { error: "Tidak ada item valid" }, status: :unprocessable_entity if transaksi.transaksi_items.empty?

        transaksi.total_amount = total

        if transaksi.save
          render json: {
            kode_transaksi: transaksi.kode_transaksi,
            total_amount: transaksi.total_amount,
            qris_string: transaksi.qris_string,
            qr_expires_at: transaksi.qr_expires_at,
            id: transaksi.id,
            status: transaksi.status,
            items: transaksi.transaksi_items.map { |i| { name: i.product&.name, qty: i.quantity, price: i.price, subtotal: i.subtotal } }
          }, status: :created
        else
          render json: { errors: transaksi.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def payment_status
        transaksi = Transaksi.find_by(id: params[:id])
        return render json: { error: "Transaksi tidak ditemukan" }, status: :not_found unless transaksi

        render json: {
          id: transaksi.id,
          kode_transaksi: transaksi.kode_transaksi,
          status: transaksi.status,
          total_amount: transaksi.total_amount,
          customer_name: transaksi.customer_name,
          qris_string: transaksi.qris_string,
          qr_expires_at: transaksi.qr_expires_at
        }
      end

      def simulate_payment
        transaksi = Transaksi.find_by(id: params[:id])
        return render json: { error: "Transaksi tidak ditemukan" }, status: :not_found unless transaksi
        return render json: { error: "Sudah dibayar" }, status: :unprocessable_entity if transaksi.dibayar?

        transaksi.update!(
          status: :dibayar,
          jam_selesai: Time.current
        )

        # Free up table for billiard
        transaksi.meja&.update!(status: :tersedia) if transaksi.billiard?

        render json: {
          id: transaksi.id,
          kode_transaksi: transaksi.kode_transaksi,
          status: transaksi.status,
          message: "Pembayaran berhasil"
        }
      end
    end
  end
end