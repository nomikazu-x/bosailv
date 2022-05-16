Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # 記事
      get  'articles',            to: 'articles#index',     as: 'articles'
      get  'articles/:id',        to: 'articles#show',      as: 'article'
      post 'articles/create',     to: 'articles#create',    as: 'create_article'
      post 'articles/:id/update', to: 'articles#update',    as: 'update_article'
      post 'articles/:id/delete', to: 'articles#destroy',   as: 'destroy_article'

      # 記事コメント
      post 'article_comments/create',     to: 'article_comments#create',    as: 'create_comment'
      post 'article_comments/:id/delete', to: 'article_comments#destroy',   as: 'delete_comment'

      # 記事お気に入り
      post 'articles/:id/article_favorites/create', to: 'article_favorites#create',    as: 'favorite_article'
      post 'articles/:id/article_favorites/delete', to: 'article_favorites#destroy',   as: 'unfavorite_article'

      # お知らせ
      get 'infomations',           to: 'infomations#index',     as: 'infomations'
      get 'infomations/important', to: 'infomations#important', as: 'important_infomations'
      get 'infomations/:id',       to: 'infomations#show',      as: 'infomation'

      
    end
  end

  scope :api do
    scope :v1 do
      # Devise Token Auth
      devise_for :users, skip: :all
      devise_scope :user do
        post 'users/auth/sign_up',         to: 'api/v1/users/auth/registrations#create',             as: 'create_user_auth_registration'
        get  'users/auth/show',            to: 'api/v1/users/auth/registrations#show',               as: 'show_user_auth_registration'
        post 'users/auth/update',          to: 'api/v1/users/auth/registrations#update',             as: 'update_user_auth_registration'
        post 'users/auth/image/update',    to: 'api/v1/users/auth/registrations#image_update',       as: 'update_user_auth_image_registration'
        post 'users/auth/image/delete',    to: 'api/v1/users/auth/registrations#image_destroy',      as: 'delete_user_auth_image_registration'
        post 'users/auth/delete',          to: 'api/v1/users/auth/registrations#destroy',            as: 'destroy_user_auth_registration'
        post 'users/auth/sign_in',         to: 'api/v1/users/auth/sessions#create',                  as: 'create_user_auth_session'
        post 'users/auth/sign_out',        to: 'api/v1/users/auth/sessions#destroy',                 as: 'destroy_user_auth_session'
        get  'users/auth/validate_token',  to: 'api/v1/users/auth/token_validations#validate_token', as: 'user_auth_validate_token'
      end
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
