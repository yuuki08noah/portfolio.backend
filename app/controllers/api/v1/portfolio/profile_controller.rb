module Api
  module V1
    module Portfolio
      class ProfileController < ApplicationController
        include Localizable
        before_action :authenticate_user!, only: [ :update ]
        
        require 'redcarpet'

        # GET /api/v1/portfolio/profile or /api/v1/:locale/portfolio/profile
        # Returns the public profile (first admin user or specified user)
        def show
          user = User.find_by(role: [ "admin", "super_admin" ])

          if user.nil?
            render json: { error: "Profile not found" }, status: :not_found
            return
          end

          render json: { profile: profile_response(user) }, status: :ok
        end

        # PUT /api/v1/portfolio/profile
        # Updates the current user's profile
        def update
          if current_user.update(profile_params)
            save_translations(current_user)
            render json: { message: "Profile updated successfully", profile: profile_response(current_user) }, status: :ok
          else
            render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def save_translations(user)
          return unless params[:translations].present?
          
          %w[ko ja].each do |locale|
            if params[:translations][locale].present?
              user.set_translations(locale, params[:translations][locale].permit(
                :name, :bio, :tagline, :job_position, :location_city, :location_country
              ).to_h)
            end
          end
        end

        def profile_params
          params.permit(
            :name, :tagline, :bio, 
            :avatar_url, :phone,
            :github_url, :linkedin_url, :twitter_url, :website_url,
            :location_country, :location_city, :job_position,
            skills: [],
            values: [ :title, :description ],
            external_links: [ :name, :url, :icon ],
            certifications: [ :name, :issuer, :date, :url ]
          )
        end

        def profile_response(user)
          ko_translations = user.translations_for('ko')
          ja_translations = user.translations_for('ja')
          
          translations_for_locale = case current_locale
                                    when 'ko' then ko_translations
                                    when 'ja' then ja_translations
                                    else {}
                                    end
          
          name = translations_for_locale['name'].presence || user.name
          tagline = translations_for_locale['tagline'].presence || user.tagline
          bio = translations_for_locale['bio'].presence || user.bio
          job_position = translations_for_locale['job_position'].presence || user.job_position
          location_country = translations_for_locale['location_country'].presence || user.location_country
          location_city = translations_for_locale['location_city'].presence || user.location_city

          {
            id: user.id,
            name: name,
            tagline: tagline,
            bio: bio,
            bio_html: markdown_to_html(bio),
            avatar_url: user.avatar_url,
            phone: user.phone,
            email: user.email,
            github_url: user.github_url,
            linkedin_url: user.linkedin_url,
            twitter_url: user.twitter_url,
            website_url: user.website_url,
            location_country: location_country,
            location_city: location_city,
            job_position: job_position,
            skills: user.skills || [],
            values: user.values || [],
            external_links: user.external_links || [],
            certifications: user.certifications || [],
            translations: {
              ko: ko_translations,
              ja: ja_translations
            }
          }
        end

        def markdown_to_html(text)
          return nil if text.blank?
          
          renderer = Redcarpet::Render::HTML.new(
            hard_wrap: true,
            link_attributes: { target: '_blank', rel: 'noopener noreferrer' }
          )
          
          markdown = Redcarpet::Markdown.new(
            renderer,
            autolink: true,
            tables: true,
            fenced_code_blocks: true,
            strikethrough: true,
            superscript: true,
            highlight: true,
            quote: true,
            footnotes: true
          )
          
          markdown.render(text)
        end
      end
    end
  end
end
