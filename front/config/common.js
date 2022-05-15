module.exports = {
  // 【ユーザー】
  // ログインAPI
  authSignInURL: '/users/auth/sign_in.json',
  authRedirectSignInURL: '/users/sign_in',
  authRedirectHomeURL: '/',
  // ログアウトAPI
  authSignOutURL: '/users/auth/sign_out.json',
  authRedirectLogOutURL: '/users/sign_in',
  // トークン検証API
  authUserURL: '/users/auth/validate_token.json',
  // アカウント登録API
  singUpUrl: '/users/auth/sign_up.json',
  singUpSuccessUrl: '/users/sign_in',
  // 登録情報詳細API
  userShowUrl: '/users/auth/show.json',
  // 登録情報変更API
  userUpdateUrl: '/users/auth/update.json',
  // 画像変更API
  userImageUpdateUrl: '/users/auth/image/update.json',
  // 画像削除API
  userImageDeleteUrl: '/users/auth/image/delete.json',
  // アカウント削除API
  userDeleteUrl: '/users/auth/delete.json',

  // 【お知らせ】
  // 大切なお知らせAPI
  importantInfomationsUrl: '/infomations/important.json',
  // お知らせ一覧API
  infomationsUrl: '/infomations.json',
  // お知らせ詳細API
  infomationDetailUrl: '/infomations/_id.json',

  // 【記事】
  // 記事一覧API
  articlesUrl: '/articles.json',
  // 記事詳細API
  articleDetailUrl: '/articles/_id.json',
  // 記事作成API
  articleCreateUrl: '/articles/create.json',
  // 記事編集API
  articleUpdateUrl: '/articles/_id/update.json',
  // 記事削除API
  articleDeleteUrl: '/articles/_id/delete.json',

  // ［お気に入り］
  // お気に入り登録API
  favoriteCreateUrl: '/articles/_id/article_favorites/create.json',
  // お気に入り解除API
  favoriteDeleteUrl: '/articles/_id/article_favorites/delete.json',

  // ［コメント］
  // コメント一覧API
  commentsUrl: '/article_comments.json',
  // コメント作成API
  commentCreateUrl: '/article_comments/create.json',
  // コメント削除API
  commentDeleteUrl: '/article_comments/_id/delete.json'
}
