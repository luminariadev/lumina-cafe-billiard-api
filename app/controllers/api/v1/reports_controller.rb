module Api
  module V1
    class ReportsController < ApplicationController

      def index
        today = Time.zone.today
        # Kasir only see their own data
        transaksi_scope = @current_user.kasir? ? Transaksi.where(user_id: @current_user.id) : Transaksi
        transactions = transaksi_scope.where(jam_mulai: today.all_day).where(status: :dibayar)
        monthly = transaksi_scope.where(jam_mulai: today.beginning_of_month..Time.current).where(status: :dibayar)

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

      # GET /api/v1/reports/analytics — sales analytics (peak hours, daily trend, top categories)
      def analytics
        return render json: { error: "Unauthorized" }, status: :forbidden unless @current_user&.admin?

        # Peak hours: transactions grouped by hour of day (last 7 days)
        peak_hours = Transaksi
          .where(status: :dibayar)
          .where("jam_mulai >= ?", 7.days.ago.beginning_of_day)
          .group("EXTRACT(HOUR FROM jam_mulai)")
          .order("count_all DESC")
          .limit(8)
          .count

        # Daily trend: last 14 days revenue per day
        daily_trend = Transaksi
          .where(status: :dibayar)
          .where("jam_mulai >= ?", 14.days.ago.beginning_of_day)
          .group("DATE(jam_mulai)")
          .sum(:total_amount)

        # Top categories by revenue
        top_categories = TransaksiItem
          .joins(product: :category, transaksi: :transaksi_type)
          .where(transaksis: { status: :dibayar })
          .where("jam_mulai >= ?", 30.days.ago.beginning_of_day)
          .group("categories.name")
          .order(Arel.sql("SUM(transaksi_items.subtotal) DESC"))
          .limit(5)
          .pluck("categories.name, SUM(transaksi_items.subtotal)")

        render json: {
          peak_hours: peak_hours.map { |hour, count| { hour: hour.to_i, count: count } },
          daily_trend: daily_trend.map { |date, amount| { date: date, revenue: amount.to_f } },
          top_categories: top_categories.map { |name, amount| { name: name, revenue: amount.to_f } }
        }
      end

      private

      def authorize_admin
        render json: { error: "Unauthorized" }, status: :forbidden unless @current_user&.admin?
      end
    end
  end
end