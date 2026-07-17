module Api
  module V1
    class ReportsController < ApplicationController
      before_action :authorize_admin

      def index
        today = Time.zone.today
        transactions = Transaksi.where(jam_mulai: today.all_day).where(status: :dibayar)
        monthly = Transaksi.where(jam_mulai: today.beginning_of_month..Time.current).where(status: :dibayar)

        today_revenue = transactions.sum(:total_amount)
        monthly_revenue = monthly.sum(:total_amount)

        best_sellers = TransaksiItem
          .joins(:product, :transaksi)
          .where(transaksis: { status: :dibayar })
          .group("products.name")
          .order(Arel.sql("SUM(transaksi_items.quantity) DESC"))
          .limit(5)
          .pluck("products.name, SUM(transaksi_items.quantity)")

        render json: {
          today_revenue: today_revenue || 0,
          monthly_revenue: monthly_revenue || 0,
          best_sellers: best_sellers.map { |name, qty| { name: name, quantity: qty.to_i } },
          today_transactions: transactions.count,
          monthly_transactions: monthly.count
        }
      end

      private

      def authorize_admin
        render json: { error: "Unauthorized" }, status: :forbidden unless @current_user&.admin?
      end
    end
  end
end