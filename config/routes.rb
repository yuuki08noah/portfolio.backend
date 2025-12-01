Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # API v1 routes
  namespace :api do
    namespace :v1 do
      # Authentication routes
      namespace :auth do
        post 'register', to: 'auth#register'
        post 'login', to: 'auth#login'
        post 'password/reset/request', to: 'auth#request_password_reset'
        post 'password/reset/confirm', to: 'auth#confirm_password_reset'
        post 'verify_email', to: 'auth#verify_email'
      end

      # Admin routes
      namespace :admin do
        get 'accounts', to: 'accounts#index'
        post 'accounts/invite', to: 'accounts#invite'
        post 'accounts/:id/approve', to: 'accounts#approve'
        post 'accounts/:id/reject', to: 'accounts#reject'
        put 'accounts/:id/status', to: 'accounts#update_status'
        post 'accounts/accept', to: 'accounts#accept'
      end
      
      # User management routes
      namespace :users do
        get 'me', to: 'users#me'
        get ':id', to: 'users#show'
        put ':id', to: 'users#update'
        delete ':id', to: 'users#destroy'
      end
      
      # Locale-based routes (ko/en/ja)
      scope ':locale', constraints: { locale: /en|ko|ja/ } do
        # Portfolio routes
        namespace :portfolio do
          get 'profile', to: 'profile#show'
          put 'profile', to: 'profile#update'

          resources :projects, param: :slug do
            get 'docs', to: 'project_docs#index'
            post 'docs', to: 'project_docs#create'
            get 'docs/:category', to: 'project_docs#by_category'
            get 'docs/:category/:doc_slug', to: 'project_docs#show'
            patch 'docs/:category/:doc_slug', to: 'project_docs#update'
            delete 'docs/:category/:doc_slug', to: 'project_docs#destroy'
            
            post 'images', to: 'project_images#create'
            delete 'images/:image_id', to: 'project_images#destroy'
          end
          
          resources :awards
          resources :milestones
        end

        # Reading routes
        namespace :reading do
          resources :books
          resources :goals, only: [:index, :create, :update, :destroy]
          get 'stats', to: 'stats#index'
        end

        # Travel routes
        namespace :travel do
          resources :diaries
          resources :plans
        end

        # Site settings
        resources :site_settings, only: [:index, :show, :update]
        post 'site_settings/bulk_update', to: 'site_settings#bulk_update'
      end
      
      # Non-locale routes (backward compatibility)
      namespace :portfolio do
        get 'profile', to: 'profile#show'
        put 'profile', to: 'profile#update'

        resources :projects, param: :slug do
          get 'docs', to: 'project_docs#index'
          post 'docs', to: 'project_docs#create'
          get 'docs/:category', to: 'project_docs#by_category'
          get 'docs/:category/:doc_slug', to: 'project_docs#show'
          patch 'docs/:category/:doc_slug', to: 'project_docs#update'
          delete 'docs/:category/:doc_slug', to: 'project_docs#destroy'
          
          post 'images', to: 'project_images#create'
          delete 'images/:image_id', to: 'project_images#destroy'
        end
        
        resources :awards
        resources :milestones
      end

      # Blog routes
      namespace :blog do
        resources :posts
        resources :categories, only: [:index, :create, :update, :destroy]
        resources :tags, only: [:index]
      end

      # Comments routes
      resources :comments, only: [:index, :create, :update, :destroy]

      # Reading routes (backward compatibility)
      namespace :reading do
        resources :books
        resources :goals, only: [:index, :create, :update, :destroy]
        get 'stats', to: 'stats#index'
      end

      # Travel routes (backward compatibility)
      namespace :travel do
        resources :diaries
        resources :plans
      end

      # Site settings (backward compatibility)
      resources :site_settings, only: [:index, :show, :update]
      post 'site_settings/bulk_update', to: 'site_settings#bulk_update'

      post 'hire', to: 'hire#submit'
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
