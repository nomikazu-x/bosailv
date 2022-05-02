Rails.application.routes.draw do
  draw :admin
  draw :articles
  draw :comments
  draw :infomations
  draw :favorites
  draw :users
  
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
