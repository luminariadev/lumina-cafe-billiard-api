module Api
  module V1
    class MejasController < ApplicationController
      skip_before_action :authorize_request, only: [:index]
      before_action :authorize_admin, only: [:create, :update, :destroy]

      def index
        render json: Meja.all.order(:nomor_meja).map { |m|
          m.as_json.merge(status: m.status)
        }
      end

      def show
        render json: Meja.find(params[:id]).as_json.merge(status: Meja.find(params[:id]).status)
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
