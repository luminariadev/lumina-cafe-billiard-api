module Api
  module V1
    class MejasController < ApplicationController
      skip_before_action :authorize_request, only: [:index, :show]
      before_action :authorize_admin, only: [:create, :update, :destroy]

      def index
        mejas = Meja.order(:nomor_meja)
        page = (params[:page] || 1).to_i
        per_page = (params[:per_page] || 50).to_i.clamp(1, 100)
        total = mejas.count
        mejas = mejas.offset((page - 1) * per_page).limit(per_page)
        render json: {
          data: mejas.map { |m| m.as_json.merge(status: m.status) },
          meta: { page: page, per_page: per_page, total: total, pages: (total.to_f / per_page).ceil }
        }
      end

      def show
        meja = Meja.find(params[:id])
        render json: meja.as_json.merge(status: meja.status)
      end

      def create
        meja = Meja.new(meja_params)
        meja.save ? (render json: meja, status: :created) : (render json: { errors: meja.errors.full_messages }, status: :unprocessable_entity)
      end

      def update
        meja = Meja.find(params[:id])
        meja.update(meja_params) ? (render json: meja) : (render json: { errors: meja.errors.full_messages }, status: :unprocessable_entity)
      end

      def destroy
        meja = Meja.find(params[:id])
        meja.destroy ? head(:no_content) : render(json: { errors: meja.errors.full_messages }, status: :unprocessable_entity)
      end

      private
      def meja_params
        params.require(:meja).permit(:nomor_meja, :status, :keterangan)
      end
    end
  end
end
