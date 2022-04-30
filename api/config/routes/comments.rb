Rails.application.routes.draw do
  get  'articles/:id/comments',        to: 'comments#index',     as: 'comments'
  post 'articles/:id/comments/create', to: 'comments#create',    as: 'create_comment'
  post 'articles/:id/comments/delete', to: 'comments#destroy',   as: 'delete_comment'
end
