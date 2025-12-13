module Api
  module V1
    class UploadsController < ApplicationController
      # Optional: Authenticate if you only want logged-in users to upload
      # before_action :authenticate_user! 

      def create
        upload = Upload.new
        upload.file.attach(params[:file])

        if upload.save
          # Check if using S3 service
          service = upload.file.blob.service
          is_s3 = service.class.name.include?('S3')
          
          is_gcs = service.class.name.include?('GCS') || service.class.name.include?('Google')
          
          url = if is_s3
                  # Direct S3 URL format
                  "https://#{ENV['AWS_S3_BUCKET']}.s3.#{ENV['AWS_REGION']}.amazonaws.com/#{upload.file.key}"
                elsif is_gcs
                  # Direct GCS URL format
                  "https://storage.googleapis.com/#{ENV['GCS_BUCKET']}/#{upload.file.key}"
                else
                  # Fallback for local storage
                  rails_blob_url(upload.file)
                end

          render json: { 
            url: url,
            filename: upload.file.filename.to_s
          }, status: :created
        else
          render json: { error: 'Failed to upload file' }, status: :unprocessable_entity
        end
      end
    end
  end
end
