Rails.application.routes.draw do
  post 'articles/:id/favorites/create', to: 'favorites#create',    as: 'favorite_article'
  post 'articles/:id/favorites/delete', to: 'favorites#destroy',   as: 'unfavorite_article'
end