module Api
  module V1
    module Portfolio
      class ProjectImagesController < ApplicationController
        before_action :authenticate_user!
        before_action :set_project

        # POST /api/v1/portfolio/projects/:slug/images
        def create
          unless params[:image].present?
            return render json: { 
              error: {
                code: 'VALIDATION_ERROR',
                message: 'Image file is required'
              }
            }, status: :bad_request
          end

          image_file = params[:image]
          
          # Validate file type
          unless valid_image_type?(image_file)
            return render json: { 
              error: {
                code: 'INVALID_FILE_TYPE',
                message: 'Only JPEG, PNG, WebP, and AVIF images are allowed'
              }
            }, status: :unprocessable_entity
          end

          # Validate file size (5MB max)
          if image_file.size > 5.megabytes
            return render json: { 
              error: {
                code: 'FILE_TOO_LARGE',
                message: 'Image must be less than 5MB'
              }
            }, status: :unprocessable_entity
          end

          # Attach image to project
          @project.souvenirs ||= []
          
          # For now, we'll just store the filename
          # In production, integrate with Active Storage
          filename = "#{SecureRandom.uuid}_#{image_file.original_filename}"
          @project.souvenirs << filename
          
          if @project.save
            render json: { 
              message: 'Image uploaded successfully',
              url: filename,
              souvenirs: @project.souvenirs
            }, status: :created
          else
            render json: { 
              error: {
                code: 'UPLOAD_FAILED',
                message: 'Failed to save image'
              }
            }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/portfolio/projects/:slug/images/:image_id
        def destroy
          image_name = params[:image_id]
          
          unless @project.souvenirs&.include?(image_name)
            return render json: { 
              error: {
                code: 'NOT_FOUND',
                message: 'Image not found'
              }
            }, status: :not_found
          end

          @project.souvenirs.delete(image_name)
          
          if @project.save
            head :no_content
          else
            render json: { 
              error: {
                code: 'DELETE_FAILED',
                message: 'Failed to delete image'
              }
            }, status: :unprocessable_entity
          end
        end

        private

        def set_project
          @project = current_user.projects.active.find_by!(slug: params[:slug])
        rescue ActiveRecord::RecordNotFound
          render json: { 
            error: {
              code: 'NOT_FOUND',
              message: 'Project not found or you do not have permission'
            }
          }, status: :not_found
        end

        def valid_image_type?(file)
          return false unless file.respond_to?(:content_type)
          
          allowed_types = [
            'image/jpeg',
            'image/png',
            'image/webp',
            'image/avif'
          ]
          
          allowed_types.include?(file.content_type)
        end
      end
    end
  end
end
