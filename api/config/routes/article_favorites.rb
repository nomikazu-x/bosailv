Rails.application.routes.draw do
  post 'articles/:id/article_favorites/create', to: 'article_favorites#create',    as: 'favorite_article'
  post 'articles/:id/article_favorites/delete', to: 'article_favorites#destroy',   as: 'unfavorite_article'
end