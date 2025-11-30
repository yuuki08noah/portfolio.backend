module Api
  module V1
    module Blog
      class CategoriesController < ApplicationController
        before_action :authenticate_user!, except: [:index]
        before_action :set_category, only: [:update, :destroy]

        def index
          categories = Category.all
          render json: { categories: categories.map { |category| category_response(category) } }, status: :ok
        end

        def create
          category = current_user.categories.new(category_params)
          if category.save
            render json: { message: 'Category created successfully', category: category_response(category) }, status: :created
          else
            render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @category.update(category_params)
            render json: { message: 'Category updated successfully', category: category_response(@category) }, status: :ok
          else
            render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @category.destroy
          render json: { message: 'Category deleted successfully' }, status: :ok
        end

        private

        def category_params
          params.permit(:name, :description, :color, :icon, :slug, :parent_id)
        end

        def category_response(category)
          {
            id: category.id,
            name: category.name,
            description: category.description,
            color: category.color,
            icon: category.icon,
            slug: category.slug,
            parent_id: category.parent_id
          }
        end

        def set_category
          @category = current_user.categories.find(params[:id])
        end
      end
    end
  end
end
