Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # [管理者権限]
      namespace :admin do
        # ユーザー
        get  'users',                      to: 'users#index',          as: 'users'
        post 'users/:username/delete',     to: 'users#destroy',        as: 'destroy_user'

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
    end
  end
end
