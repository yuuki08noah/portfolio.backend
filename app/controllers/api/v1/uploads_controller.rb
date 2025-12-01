module Api
  module V1
    class UploadsController < ApplicationController
      # Optional: Authenticate if you only want logged-in users to upload
      # before_action :authenticate_user! 

      def create
        upload = Upload.new
        upload.file.attach(params[:file])

        if upload.save
          render json: { 
            url: upload.file.url,
            filename: upload.file.filename.to_s
          }, status: :created
        else
          render json: { error: 'Failed to upload file' }, status: :unprocessable_entity
        end
      end
    end
  end
end
