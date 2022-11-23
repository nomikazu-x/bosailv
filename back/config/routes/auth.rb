Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      get  'users/confirmation',        to: 'users/confirmations#show',          as: 'user_confirmation' # Tips: メールアドレス確認に必要
      get  'users/unlock',              to: 'users/unlocks#show',                as: 'user_unlock' # Tips: アンロックに必要
      get  'users/password',            to: 'users/passwords#edit',              as: 'edit_user_password' # Tips: パスワード変更に必要

      # Devise Token Auth
      devise_for :users, skip: :all
      devise_scope :user do
        post 'auth/sign_up',         to: 'api/v1/auth/registrations#create',             as: 'create_auth_registration'
        get  'auth/detail',          to: 'api/v1/auth/registrations#show',               as: 'show_auth_registration'
        post 'auth/update',          to: 'api/v1/auth/registrations#update',             as: 'update_auth_registration'
        post 'auth/profile/update',  to: 'api/v1/auth/registrations#profile_update',     as: 'update_auth_profile_registration'
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
end
