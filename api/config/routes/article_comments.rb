Rails.application.routes.draw do
  post 'article_comments/create',     to: 'article_comments#create',    as: 'create_comment'
  post 'article_comments/:id/delete', to: 'article_comments#destroy',   as: 'delete_comment'
end
