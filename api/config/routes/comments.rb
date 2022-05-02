Rails.application.routes.draw do
  post 'comments/create',     to: 'comments#create',    as: 'create_comment'
  post 'comments/:id/delete', to: 'comments#destroy',   as: 'delete_comment'
end
