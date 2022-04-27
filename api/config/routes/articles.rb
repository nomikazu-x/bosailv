Rails.application.routes.draw do
  get 'articles',           to: 'articles#index',     as: 'articles'
end