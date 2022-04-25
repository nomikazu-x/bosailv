Rails.application.routes.draw do
  draw :admin
  draw :infomations
  draw :users
  
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
