module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :authorize_admin, only: [:create, :update, :destroy]

      def index
        categories = Category.all.order(:name)
        # Load product_counts for each category
        category_product_counts = Product.group(:category_id).count

        render json: categories.map do |category|
          category.as_json.merge(product_count: category_product_counts[category.id] || 0)
        end
      end

      def show
        category = Category.find(params[:id])
        render json: category.as_json.merge(product_count: category.products.count)
      end

      def create
        category = Category.new(category_params)
        if category.save
          render json: category, status: :created
        else
          render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        category = Category.find(params[:id])
        if category.update(category_params)
          render json: category
        else
          render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        category = Category.find(params[:id])
        if category.destroy
          head :no_content
        else
          render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def category_params
        params.require(:category).permit(:name, :description)
      end
    end
  end
end