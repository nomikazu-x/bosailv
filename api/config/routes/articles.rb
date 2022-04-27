Rails.application.routes.draw do
  get 'articles',           to: 'articles#index',     as: 'articles'
  get 'articles/:id',       to: 'articles#show',      as: 'article'
end