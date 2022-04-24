Rails.application.routes.draw do
  devise_for :admin_users, controllers: {
    sessions: 'admin_users/sessions'
  }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
