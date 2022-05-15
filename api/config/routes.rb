Rails.application.routes.draw do
  draw :articles
  draw :article_comments
  draw :infomations
  draw :article_favorites
  draw :users
  
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
