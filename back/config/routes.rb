Rails.application.routes.draw do
  draw :admin
  draw :auth

  namespace :api do
    namespace :v1 do
      # ユーザー
      get   'users',                      to: 'users#index',          as: 'users'
      get   'users/:username',            to: 'users#show',           as: 'user'

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
      get  'shelters/:id',          to: 'shelters#show',    as: 'shelter'

      # 避難所登録
      post 'shelters/:id/shelter_registrations/create', to: 'shelter_registrations#create',    as: 'registration_shelter'
      post 'shelters/:id/shelter_registrations/delete', to: 'shelter_registrations#destroy',   as: 'unregistration_shelter'
      
      # 記事
      get  'articles',            to: 'articles#index',        as: 'articles'
      post 'articles/create',     to: 'articles#create',       as: 'create_article'
      post 'articles/:id/update', to: 'articles#update',       as: 'update_article'
      post 'articles/:id/delete', to: 'articles#destroy',      as: 'destroy_article'
      get  'articles/:id',        to: 'articles#show',         as: 'article'

      # 記事コメント
      get  'articles/:article_id/article_comments',                to: 'article_comments#index',     as: 'comments'
      post 'articles/:article_id/article_comments/create',         to: 'article_comments#create',    as: 'create_comment'
      post 'articles/:article_id/article_comments/:id/delete',       to: 'article_comments#destroy',   as: 'destroy_comment'

      # 記事お気に入り
      post 'articles/:id/article_favorites/create', to: 'article_favorites#create',    as: 'favorite_article'
      post 'articles/:id/article_favorites/delete', to: 'article_favorites#destroy',   as: 'unfavorite_article'      

      # ジャンル
      get  'genres',              to: 'genres#index',   as: 'genres'
      get  'genres/:id',          to: 'genres#show',    as: 'genre'

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

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
