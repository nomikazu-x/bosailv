Rails.application.routes.draw do
  devise_for :admin_users, controllers: {
    sessions: 'admin_users/sessions'
  }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users, skip: :all
  devise_scope :user do
    # Devise Token Auth
    post 'users/auth/sign_up',         to: 'users/auth/registrations#create',             as: 'create_user_auth_registration'
    get  'users/auth/show',            to: 'users/auth/registrations#show',               as: 'show_user_auth_registration'
    post 'users/auth/update',          to: 'users/auth/registrations#update',             as: 'update_user_auth_registration'
    post 'users/auth/image/update',    to: 'users/auth/registrations#image_update',       as: 'update_user_auth_image_registration'
    post 'users/auth/image/delete',    to: 'users/auth/registrations#image_destroy',      as: 'delete_user_auth_image_registration'
    post 'users/auth/delete',          to: 'users/auth/registrations#destroy',            as: 'destroy_user_auth_registration'
    post 'users/auth/sign_in',         to: 'users/auth/sessions#create',                  as: 'create_user_auth_session'
    post 'users/auth/sign_out',        to: 'users/auth/sessions#destroy',                 as: 'destroy_user_auth_session'
    get  'users/auth/validate_token',  to: 'users/auth/token_validations#validate_token', as: 'user_auth_validate_token'
  end

  get 'infomations',           to: 'infomations#index',     as: 'infomations'
  get 'infomations/important', to: 'infomations#important', as: 'important_infomations'
  get 'infomations/:id',       to: 'infomations#show',      as: 'infomation'
  
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
