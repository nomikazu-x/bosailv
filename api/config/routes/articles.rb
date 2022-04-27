Rails.application.routes.draw do
  get  'articles',           to: 'articles#index',     as: 'articles'
  get  'articles/:id',       to: 'articles#show',      as: 'article'
  post 'articles/create',    to: 'articles#create',    as: 'create_article'
end
