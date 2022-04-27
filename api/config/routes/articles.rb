Rails.application.routes.draw do
  get  'articles',            to: 'articles#index',     as: 'articles'
  get  'articles/:id',        to: 'articles#show',      as: 'article'
  post 'articles/create',     to: 'articles#create',    as: 'create_article'
  post 'articles/:id/update', to: 'articles#update',    as: 'update_article'
  post 'articles/:id/delete', to: 'articles#destroy',   as: 'destroy_article'
end
