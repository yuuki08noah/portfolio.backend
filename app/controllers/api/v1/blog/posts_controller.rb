module Api
  module V1
    module Blog
      class PostsController < ApplicationController
        before_action :authenticate_user!, except: [:index, :show]
        before_action :set_post, only: [:show]
        before_action :set_owned_post, only: [:update, :destroy]

        def index
          posts = BlogPost.all
          posts = posts.published_public unless current_user
          posts = posts.where(status: params[:status]) if params[:status].present?
          posts = posts.where(category_id: params[:category_id]) if params[:category_id].present?
          posts = posts.where("title LIKE :q OR subtitle LIKE :q OR content LIKE :q", q: "%#{params[:q]}%") if params[:q].present?

          if params[:tag].present?
            posts = posts.where("tags LIKE ?", "%#{params[:tag]}%")
          end

          render json: { posts: posts.recent.map { |post| post_response(post) } }, status: :ok
        end

        def show
          if !current_user && !(@post.published? && @post.is_public)
            return render json: { error: 'Post not found' }, status: :not_found
          end

          render json: { post: post_response(@post) }, status: :ok
        end

        def create
          post = current_user.blog_posts.new(post_params)
          if post.save
            render json: { message: 'Post created successfully', post: post_response(post) }, status: :created
          else
            render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @post.update(post_params)
            render json: { message: 'Post updated successfully', post: post_response(@post) }, status: :ok
          else
            render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @post.destroy
          render json: { message: 'Post deleted successfully' }, status: :ok
        end

        private

        def post_params
          params.permit(
            :title,
            :subtitle,
            :slug,
            :content,
            :excerpt,
            :cover_image,
            :status,
            :published_at,
            :scheduled_at,
            :is_public,
            :category_id,
            :views,
            tags: []
          )
        end

        def post_response(post)
          {
            id: post.id,
            title: post.title,
            subtitle: post.subtitle,
            slug: post.slug,
            content: post.content,
            excerpt: post.excerpt,
            cover_image: post.cover_image,
            status: post.status,
            is_public: post.is_public,
            published_at: post.published_at,
            scheduled_at: post.scheduled_at,
            tags: post.tags || [],
            category_id: post.category_id,
            views: post.views
          }
        end

        def set_post
          @post = BlogPost.find_by!(slug: params[:id])
        rescue ActiveRecord::RecordNotFound
          @post = BlogPost.find(params[:id])
        end

        def set_owned_post
          @post = current_user.blog_posts.find(params[:id])
        end
      end
    end
  end
end
