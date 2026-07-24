module Api
  module V1
    class ProductsController < ApplicationController
      skip_before_action :authorize_request, only: [:index, :show]
      before_action :authorize_admin, only: [:create, :update, :destroy]

      def index
        products = Product.includes(:category).order(:name)
        products = products.where(product_type: params[:type]) if params[:type].present?
        page = (params[:page] || 1).to_i
        per_page = (params[:per_page] || 50).to_i.clamp(1, 100)
        total = products.count
        products = products.offset((page - 1) * per_page).limit(per_page)
        render json: {
          data: products.map { |p|
            p.as_json.merge(
              active: p.active?,
              product_type: p.product_type,
              price: p.price.to_f
            )
          },
          meta: { page: page, per_page: per_page, total: total, pages: (total.to_f / per_page).ceil }
        }
      end

      def show
        product = Product.includes(:category).find(params[:id])
        render json: product.as_json.merge(active: product.active?)
      end

      def create
        product = Product.new(product_params)
        if product.save
          render json: product, status: :created
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        product = Product.find(params[:id])
        if product.update(product_params)
          render json: product
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        product = Product.find(params[:id])
        product.destroy ? head(:no_content) : render(json: { errors: product.errors.full_messages }, status: :unprocessable_entity)
      end

      private
      def product_params
        params.require(:product).permit(:category_id, :name, :price, :stock, :product_type, :status)
      end
    end
  end
end
