module Api
  module V1
    module Blog
      class TagsController < ApplicationController
        def index
          tags = Tag.all
          render json: { tags: tags.map { |tag| tag_response(tag) } }, status: :ok
        end

        private

        def tag_response(tag)
          {
            id: tag.id,
            name: tag.name,
            slug: tag.slug,
            usage_count: tag.usage_count,
            post_count: tag.post_count
          }
        end
      end
    end
  end
end
