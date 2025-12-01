# Guide for S3 Integration with Rails ActiveStorage

## 1. Gemfile에 aws-sdk-s3 추가

```ruby
# Add to Gemfile
gem "aws-sdk-s3", require: false
```

그 다음 실행:

```bash
bundle install
```

## 2. config/storage.yml 설정

```yaml
amazon:
  service: S3
  access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
  region: <%= ENV['AWS_REGION'] %>
  bucket: <%= ENV['AWS_S3_BUCKET'] %>
```

## 3. 환경 변수 설정 (.env)

```env
AWS_ACCESS_KEY_ID=your_access_key_id
AWS_SECRET_ACCESS_KEY=your_secret_access_key
AWS_REGION=ap-northeast-2
AWS_S3_BUCKET=your-bucket-name
```

## 4. config/environments/production.rb 설정

```ruby
config.active_storage.service = :amazon
```

## 5. User 모델에 avatar 추가

```ruby
# app/models/user.rb
class User < ApplicationRecord
  has_one_attached :avatar
end
```

## 6. Avatar 업로드 엔드포인트 생성

```ruby
# app/controllers/api/v1/users_controller.rb
def upload_avatar
  user = User.find(params[:id])
  
  if user.avatar.attach(params[:avatar])
    render json: { 
      avatar_url: url_for(user.avatar),
      message: 'Avatar uploaded successfully' 
    }
  else
    render json: { error: 'Failed to upload avatar' }, status: :unprocessable_entity
  end
end
```

## 7. Routes 추가

```ruby
# config/routes.rb
namespace :api do
  namespace :v1 do
    resources :users do
      member do
        post :avatar, to: 'users#upload_avatar'
      end
    end
  end
end
```

## 8. CORS 설정 (이미 되어 있을 수 있음)

```ruby
# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization']
  end
end
```

## 실행 순서

1. `bundle add aws-sdk-s3`
2. `.env` 파일에 AWS 자격 증명 추가
3. `config/storage.yml`에 amazon 서비스 설정
4. User 모델에 `has_one_attached :avatar` 추가
5. Controller에 upload_avatar 액션 추가
6. Routes 추가
7. 서버 재시작

완료!
