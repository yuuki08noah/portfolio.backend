module Api
  module V1
    module Portfolio
      class ProjectsController < ApplicationController
        before_action :authenticate_user!, except: [:index, :show]
        before_action :authenticate_admin!, except: [:index, :show]
        before_action :set_project, only: [:show, :update, :destroy]

        # GET /api/v1/portfolio/projects
        def index
          projects = Project.active.recent
          render json: { projects: projects.map { |p| project_response(p) } }, status: :ok
        end

        # GET /api/v1/portfolio/projects/:slug
        def show
          render json: { project: project_response(@project) }, status: :ok
        end

        # POST /api/v1/portfolio/projects
        def create
          project = current_user.projects.new(project_params)
          
          if project.save
            render json: { 
              message: 'Project created successfully',
              project: project_response(project)
            }, status: :created
          else
            render json: { 
              error: {
                code: 'VALIDATION_ERROR',
                message: 'Validation failed',
                details: project.errors.full_messages.map { |msg| { message: msg } }
              }
            }, status: :unprocessable_entity
          end
        end

        # PATCH /api/v1/portfolio/projects/:slug
        def update
          if @project.update(project_params)
            render json: { 
              message: 'Project updated successfully',
              project: project_response(@project)
            }, status: :ok
          else
            render json: { 
              error: {
                code: 'VALIDATION_ERROR',
                message: 'Validation failed',
                details: @project.errors.full_messages.map { |msg| { message: msg } }
              }
            }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/portfolio/projects/:slug
        def destroy
          @project.destroy
          head :no_content
        end

        private

        def set_project
          @project = Project.active.find_by!(slug: params[:slug])
        rescue ActiveRecord::RecordNotFound
          render json: { 
            error: {
              code: 'NOT_FOUND',
              message: 'Project not found'
            }
          }, status: :not_found
        end

        def project_params
          params.permit(:title, :description, :demo_url, :repo_url, :start_date, :end_date, :is_ongoing,
                       itinerary: [], souvenirs: [], stack: [])
        end

        def project_response(project)
          {
            id: project.id,
            slug: project.slug,
            title: project.title,
            description: project.description,
            itinerary: project.itinerary,
            souvenirs: project.souvenirs,
            stack: project.stack,
            links: {
              demo: project.demo_url,
              repo: project.repo_url
            },
            start_date: project.start_date,
            end_date: project.end_date,
            is_ongoing: project.is_ongoing,
            created_at: project.created_at,
            updated_at: project.updated_at
          }
        end
      end
    end
  end
end
