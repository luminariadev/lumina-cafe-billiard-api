module Api
  module V1
    class TransaksisController < ApplicationController
      before_action :authorize_admin, only: [:report]

            def index
                    transaksis = Transaksi.includes(:user, :meja, transaksi_items: :product).order(created_at: :desc)
                    transaksis = transaksis.where(transaksi_type: params[:type]) if params[:type].present?
                    transaksis = transaksis.where(status: params[:status]) if params[:status].present?
                    # Kasir only see their own transactions
                    transaksis = transaksis.where(user_id: @current_user.id) if @current_user&.kasir?

                    page = (params[:page] || 1).to_i
                    per_page = (params[:per_page] || 50).to_i.clamp(1, 100)
                    total = transaksis.count
                    transaksis = transaksis.offset((page - 1) * per_page).limit(per_page)

                    render json: {
                      data: transaksis.as_json(include: [:user, :meja, { transaksi_items: { include: :product } }]),
                      meta: { page: page, per_page: per_page, total: total, pages: (total.to_f / per_page).ceil }
                    }
                  end
              total = transaksis.count
              transaksis = transaksis.offset((page - 1) * per_page).limit(per_page)
              render json: {
                data: transaksis.as_json(include: [:user, :meja, { transaksi_items: { include: :product } }]),
                meta: { page: page, per_page: per_page, total: total, pages: (total.to_f / per_page).ceil }
              }
            end

      def show
        transaksi = Transaksi.includes(:user, :meja, transaksi_items: :product).find(params[:id])
        render json: transaksi.as_json(include: [:user, :meja, { transaksi_items: { include: :product } }])
      end

      def create
        transaksi = Transaksi.new(transaksi_params)
        transaksi.user = @current_user
        if @current_user.kasir_billiard?
          transaksi.transaksi_type = :billiard
        elsif @current_user.kasir_cafe?
          transaksi.transaksi_type = :cafe
        end
        transaksi.save ? (render json: transaksi, status: :created) : (render json: { errors: transaksi.errors.full_messages }, status: :unprocessable_entity)
      end

      def pay
        transaksi = Transaksi.find(params[:id])
        transaksi.status = :dibayar
        transaksi.payment_method = params[:payment_method] || :tunai
        transaksi.jam_selesai = Time.current
        transaksi.save ? render(json: transaksi) : render(json: { errors: transaksi.errors.full_messages }, status: :unprocessable_entity)
      end

      def cafe_pos
        service = TransactionService.new(
          user: @current_user,
          payment_method: params[:payment_method] || :tunai,
          items: params[:items] || {}
        )
        result = service.call
        if result.success?
          render json: result.transaction, status: :created
        else
          render json: { error: result.error }, status: :unprocessable_entity
        end
      end

      def report
        date = (params[:date]&.to_date || Date.current)
        transaksis = Transaksi.where(created_at: date.beginning_of_day..date.end_of_day, status: :dibayar)
        render json: {
          date: date,
          total_billiard: transaksis.billiard.sum(:total_amount),
          total_cafe: transaksis.cafe.sum(:total_amount),
          total_all: transaksis.sum(:total_amount),
          count: transaksis.count,
          details: transaksis.as_json(include: [:user, :meja, { transaksi_items: :product }])
        }
      end

      private
      def transaksi_params
        params.require(:transaksi).permit(:meja_id, :customer_name, :payment_method, transaksi_items_attributes: [:product_id, :quantity, :notes])
      end
    end
  end
end
