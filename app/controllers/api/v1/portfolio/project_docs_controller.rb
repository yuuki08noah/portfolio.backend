module Api
  module V1
    module Portfolio
      class ProjectDocsController < ApplicationController
        before_action :authenticate_user!, except: [:index, :by_category, :show]
        before_action :set_project
        before_action :set_doc, only: [:show, :update, :destroy]

        # GET /api/v1/portfolio/projects/:slug/docs
        def index
          docs = @project.blog_posts.ordered
          render json: { docs: docs.map { |d| doc_response(d) } }, status: :ok
        end

        # GET /api/v1/portfolio/projects/:slug/docs/:category
        def by_category
          docs = @project.blog_posts.by_category(params[:category]).ordered
          render json: { docs: docs.map { |d| doc_response(d) } }, status: :ok
        end

        # GET /api/v1/portfolio/projects/:slug/docs/:category/:doc_slug
        def show
          render json: { doc: doc_response(@doc) }, status: :ok
        end

        # POST /api/v1/portfolio/projects/:slug/docs
        def create
          doc = @project.blog_posts.new(doc_params)
          
          if doc.save
            render json: { 
              message: 'Document created successfully',
              doc: doc_response(doc)
            }, status: :created
          else
            render json: { 
              error: {
                code: 'VALIDATION_ERROR',
                message: 'Validation failed',
                details: doc.errors.full_messages.map { |msg| { message: msg } }
              }
            }, status: :unprocessable_entity
          end
        end

        # PATCH /api/v1/portfolio/projects/:slug/docs/:category/:doc_slug
        def update
          if @doc.update(doc_params)
            render json: { 
              message: 'Document updated successfully',
              doc: doc_response(@doc)
            }, status: :ok
          else
            render json: { 
              error: {
                code: 'VALIDATION_ERROR',
                message: 'Validation failed',
                details: @doc.errors.full_messages.map { |msg| { message: msg } }
              }
            }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/portfolio/projects/:slug/docs/:category/:doc_slug
        def destroy
          @doc.destroy
          head :no_content
        end

        private

        def set_project
          slug_param = params[:slug] || params[:project_slug]
          Rails.logger.info "set_project - params[:slug]: #{params[:slug]}, params[:project_slug]: #{params[:project_slug]}"
          @project = Project.active.find_by!(slug: slug_param)
        rescue ActiveRecord::RecordNotFound
          render json: { 
            error: {
              code: 'NOT_FOUND',
              message: "Project not found with slug: #{slug_param}"
            }
          }, status: :not_found
        end

        def set_doc
          @doc = @project.blog_posts.find_by!(
            category: params[:category],
            slug: params[:doc_slug]
          )
        rescue ActiveRecord::RecordNotFound
          render json: { 
            error: {
              code: 'NOT_FOUND',
              message: 'Document not found'
            }
          }, status: :not_found
        end

        def doc_params
          params.permit(:category, :title, :content, :order, :velog_url, :velog_post_id)
        end

        def doc_response(doc)
          {
            id: doc.id,
            category: doc.category,
            title: doc.title,
            slug: doc.slug,
            content: doc.content,
            order: doc.order,
            velog_url: doc.velog_url,
            velog_post_id: doc.velog_post_id,
            velog_stats: {
              likes: doc.velog_likes,
              comments: doc.velog_comments,
              views: doc.velog_views,
              synced_at: doc.velog_synced_at
            },
            created_at: doc.created_at,
            updated_at: doc.updated_at
          }
        end
      end
    end
  end
end
