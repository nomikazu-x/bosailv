Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # [管理者権限]
      namespace :admin do
        # ユーザー
        get  'users',                      to: 'users#index',          as: 'users'
        get  'users/search',               to: 'users#search',         as: 'search_users'
        post 'users/:username/delete',     to: 'users#destroy',        as: 'destroy_users'

        # ジャンル
        post 'genres/create',       to: 'genres#create',       as: 'create_genre'
        post 'genres/:id/update',   to: 'genres#update',       as: 'update_genre'
        post 'genres/:id/delete',   to: 'genres#destroy',      as: 'destroy_genre'

        # お知らせ
        get  'infomations',            to: 'infomations#index',     as: 'infomations'
        post 'infomations/create',     to: 'infomations#create',    as: 'create_infomation'
        post 'infomations/:id/delete', to: 'infomations#destroy',   as: 'destroy_infomation'

        # 防災タスク
        post 'tasks/create',       to: 'tasks#create',       as: 'create_task'
        post 'tasks/:id/update',   to: 'tasks#update',       as: 'update_task'
        post 'tasks/:id/delete',   to: 'tasks#destroy',      as: 'destroy_task'
      end

      # ユーザー
      get   'users',                      to: 'users#index',          as: 'users'
      get   'users/:username',            to: 'users#show',           as: 'show_users'
      get   'users/:username/genres/:id', to: 'users#genre_articles', as: 'genre_articles_users'
      get   'users/:username/articles',   to: 'users#articles',       as: 'articles_users'
      get   'users/:username/shelters',   to: 'users#shelters',       as: 'shelters_users'

      # ユーザー防災タスクプロフィール
      get  'task_profile',             to: 'task_profiles#show',          as: 'task_profile'
      post 'task_profiles/update',     to: 'task_profiles#update',        as: 'update_task_profile'
      post 'task_profiles/delete',     to: 'task_profiles#destroy',       as: 'delete_task_profile'

      # 家族会議
      get  'family_rule',             to: 'family_rules#show',          as: 'family_rule'
      post 'family_rules/update',     to: 'family_rules#update',        as: 'update_family_rule'
      post 'family_rules/delete',     to: 'family_rules#destroy',       as: 'delete_family_rule'

      # 緊急連絡先
      get  'emergency_contacts',            to: 'emergency_contacts#index',        as: 'emergency_contacts'
      post 'emergency_contacts/create',     to: 'emergency_contacts#create',       as: 'create_emergency_contact'
      post 'emergency_contacts/:id/delete', to: 'emergency_contacts#destroy',      as: 'destroy_emergency_contact'

      # 家族構成
      get  'families',            to: 'families#index',         as: 'families'
      post 'families/create',     to: 'families#create',        as: 'create_family'
      post 'families/:id/delete', to: 'families#destroy',       as: 'delete_family'

      # 備蓄品
      get  'stocks',              to: 'stocks#index',           as: 'stocks'

      # ハザードマップ
      get  'hazard_map',          to: 'hazard_maps#show',       as: 'hazard_map'

      # 避難所
      get  'shelters',              to: 'shelters#index',   as: 'shelters'
      get  'shelters/:id',          to: 'shelters#show',    as: 'show_shelter'

      # 避難所登録
      post 'shelters/:id/shelter_registrations/create', to: 'shelter_registrations#create',    as: 'registration_shelter'
      post 'shelters/:id/shelter_registrations/delete', to: 'shelter_registrations#destroy',   as: 'unregistration_shelter'
      
      # 記事
      get  'articles',            to: 'articles#index',        as: 'articles'
      post 'articles/create',     to: 'articles#create',       as: 'create_article'
      post 'articles/:id/update', to: 'articles#update',       as: 'update_article'
      post 'articles/:id/delete', to: 'articles#destroy',      as: 'destroy_article'
      get  'articles/search',     to: 'articles#search',       as: 'search_articles'
      get  'articles/:id',        to: 'articles#show',         as: 'article'

      # 記事コメント
      get  'articles/:id/article_comments', to: 'article_comments#index',     as: 'comments'
      post 'article_comments/create',       to: 'article_comments#create',    as: 'create_comment'
      post 'article_comments/:id/delete',   to: 'article_comments#destroy',   as: 'delete_comment'

      # 記事お気に入り
      post 'articles/:id/article_favorites/create', to: 'article_favorites#create',    as: 'favorite_article'
      post 'articles/:id/article_favorites/delete', to: 'article_favorites#destroy',   as: 'unfavorite_article'      

      # ジャンル
      get  'genres',              to: 'genres#index',   as: 'genres'
      get  'genres/:id',          to: 'genres#show',    as: 'show_genre'

      # お知らせ
      get  'infomations',            to: 'infomations#index',     as: 'infomations'
      get  'infomations/important',  to: 'infomations#important', as: 'important_infomations'
      get  'infomations/:id',        to: 'infomations#show',      as: 'infomation'

      # 都道府県
      get 'prefectures', to: 'prefectures#index', as: 'prefectures'

      # 市町村
      get 'set_cities/:id', to: 'cities#set_cities', as: 'set_cities'

      # 防災タスク
      get  'tasks',              to: 'tasks#index',   as: 'tasks'
      get  'tasks/:id',          to: 'tasks#show',    as: 'show_task'

      # 防災タスク完了
      post 'tasks/:id/task_completes/create', to: 'task_completes#create',    as: 'complete_task'
      post 'tasks/:id/task_completes/delete', to: 'task_completes#destroy',   as: 'uncomplete_task'
    end
    
    get :health_check, to: 'health_check#index'
  end

  scope :api do
    scope :v1 do
      # Devise Token Auth
      devise_for :users, skip: :all
      devise_scope :user do
        post 'auth/sign_up',         to: 'api/v1/auth/registrations#create',             as: 'create_auth_registration'
        post 'auth/update',          to: 'api/v1/auth/registrations#update',             as: 'update_auth_registration'
        post 'auth/image/update',    to: 'api/v1/auth/registrations#image_update',       as: 'update_auth_image_registration'
        post 'auth/image/delete',    to: 'api/v1/auth/registrations#image_destroy',      as: 'delete_auth_image_registration'
        post 'auth/delete',          to: 'api/v1/auth/registrations#destroy',            as: 'destroy_auth_registration'
        post 'auth/confirmation',    to: 'api/v1/auth/confirmations#create',             as: 'create_auth_confirmation'
        get  'auth/confirmation',    to: 'api/v1/auth/confirmations#show',               as: 'auth_confirmation'
        post 'auth/sign_in',         to: 'api/v1/auth/sessions#create',                  as: 'create_auth_session'
        post 'auth/guest_sign_in',   to: 'api/v1/auth/sessions#create_guest',            as: 'create_guest_auth_session'
        post 'auth/sign_out',        to: 'api/v1/auth/sessions#destroy',                 as: 'destroy_auth_session'
        post 'auth/unlock',          to: 'api/v1/auth/unlocks#create',                   as: 'create_auth_unlock'
        get  'auth/unlock',          to: 'api/v1/auth/unlocks#show',                     as: 'auth_unlock'
        post 'auth/password',        to: 'api/v1/auth/passwords#create',                 as: 'create_auth_password'
        get  'auth/password',        to: 'api/v1/auth/passwords#edit',                   as: 'edit_auth_password'
        post 'auth/password/update', to: 'api/v1/auth/passwords#update',                 as: 'update_auth_password'
        get  'auth/validate_token',  to: 'api/v1/auth/token_validations#validate_token', as: 'auth_validate_token'
      end
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
