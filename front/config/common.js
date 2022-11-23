module.exports = {
  // <管理者権限>
  // 【ユーザー】
  // ユーザー一覧API
  adminUsersUrl: '/api/v1/admin/users.json',
  // アカウント削除API
  adminUserDeleteUrl: '/api/v1/admin/users/_username/delete.json',

  // 【お知らせ】
  // お知らせ一覧API
  adminInfomationsUrl: '/api/v1/admin/infomations.json',
  // お知らせ作成API
  adminInfomationCreateUrl: '/api/v1/admin/infomations/create.json',
  // お知らせ削除API
  adminInfomationDeleteUrl: '/api/v1/admin/infomations/_id/delete.json',

  // 【ジャンル】
  // ジャンル作成API
  adminGenreCreateUrl: '/api/v1/admin/genres/create.json',
  // ジャンル更新API
  adminGenreUpdateUrl: '/api/v1/admin/genres/_id/update.json',
  // ジャンル削除API
  adminGenreDeleteUrl: '/api/v1/admin/genres/_id/delete.json',

  // 【防災タスク】
  // 防災タスク作成API
  adminTaskCreateUrl: '/api/v1/admin/tasks/create.json',
  // 防災タスク更新API
  adminTaskUpdateUrl: '/api/v1/admin/tasks/_id/update.json',
  // 防災タスク削除API
  adminTaskDeleteUrl: '/api/v1/admin/tasks/_id/delete.json',

  // 【共通】
  // 【ユーザー】
  // ログインAPI
  authSignInURL: '/api/v1/auth/sign_in.json',
  authRedirectSignInURL: '/signin',
  authRedirectHomeURL: '/home',
  authFirstTimeRedirectURL: '/settings/profile',
  // ログアウトAPI
  authSignOutURL: '/api/v1/auth/sign_out.json',
  authRedirectLogOutURL: '/signin',
  // ゲストログインAPI
  guestSignInUrl: '/api/v1/auth/guest_sign_in.json',
  // トークン検証API
  authUserURL: '/api/v1/auth/validate_token.json',
  // アカウント登録API
  singUpUrl: '/api/v1/auth/sign_up.json',
  singUpSuccessUrl: '/signin',
  // メールアドレス確認API
  confirmationNewUrl: '/api/v1/auth/confirmation.json',
  confirmationSuccessUrl: '/signin',
  // アカウントロック解除API
  unlockNewUrl: '/api/v1/auth/unlock.json',
  unlockRedirectUrl: '/signin',
  // パスワード再設定API
  passwordNewUrl: '/api/v1/auth/password.json',
  passwordRedirectUrl: '/password/reset/confirm',
  passwordUpdateUrl: '/api/v1/auth/password/update.json',
  // 登録情報詳細API
  userDetailUrl: '/api/v1/auth/detail.json',
  // ユーザーAPI
  usersUrl: '/api/v1/users.json',
  // ユーザー情報詳細API
  userShowUrl: '/api/v1/users/_username.json',
  // ジャンル別記事一覧API
  userGenreArticlesUrl: '/api/v1/users/_username/genres/_id.json',
  // 登録情報変更API
  userUpdateUrl: '/api/v1/auth/update.json',
  // プロフィール変更API
  userProfileUpdateUrl: '/api/v1/auth/profile/update.json',
  // 画像変更API
  userImageUpdateUrl: '/api/v1/auth/image/update.json',
  // 画像削除API
  userImageDeleteUrl: '/api/v1/auth/image/delete.json',
  // 退会API
  userDeactivateUrl: '/api/v1/auth/delete.json',

  // 【防災タスクプロフィール】
  // 防災タスクプロフィール取得API
  taskProfileUrl: '/api/v1/task_profile.json',
  // 防災タスクプロフィール更新API
  taskProfileUpdateUrl: '/api/v1/task_profiles/update.json',
  // 防災タスクプロフィールリセットAPI
  taskProfileDeleteUrl: '/api/v1/task_profiles/delete.json',

  // 【家族ルール】
  // 家族ルール取得API
  familyRuleUrl: '/api/v1/family_rule.json',
  // 家族ルール更新API
  familyRuleUpdateUrl: '/api/v1/family_rules/update.json',
  // 家族ルールリセットAPI
  familyRuleDeleteUrl: '/api/v1/family_rules/delete.json',

  // 【家族構成】
  // 家族構成更新API
  familiesUrl: '/api/v1/families.json',
  // 家族構成更新API
  familyCreateUrl: '/api/v1/families/create.json',
  // 緊急連絡先削除API
  familyDeleteUrl: '/api/v1/families/_id/delete.json',

  // 【備蓄品】
  // 備蓄品一覧API
  stocksUrl: '/api/v1/stocks.json',

  // 【ハザードマップ】
  // ハザードマップAPI
  hazardMapUrl: '/api/v1/hazard_map.json',

  // 【避難所】
  // 避難所一覧API
  sheltersUrl: '/api/v1/shelters.json',
  // 避難所詳細API
  shelterShowUrl: '/api/v1/shelters/_id.json',

  // 【避難所登録】
  // 避難所登録API
  shelterRegistrationCreateUrl: '/api/v1/shelters/_id/shelter_registrations/create.json',
  // 避難所登録解除API
  shelterRegistrationDeleteUrl: '/api/v1/shelters/_id/shelter_registrations/delete.json',

  // 【緊急連絡先】
  // 緊急連絡先一覧API
  emergencyContactsUrl: '/api/v1/emergency_contacts.json',
  // 緊急連絡先作成API
  emergencyContactCreateUrl: '/api/v1/emergency_contacts/create.json',
  // 緊急連絡先削除API
  emergencyContactDeleteUrl: '/api/v1/emergency_contacts/_id/delete.json',

  // 【お知らせ】
  // 大切なお知らせAPI
  importantInfomationsUrl: '/api/v1/infomations/important.json',
  // お知らせ一覧API
  infomationsUrl: '/api/v1/infomations.json',
  // お知らせ詳細API
  infomationDetailUrl: '/api/v1/infomations/_id.json',

  // 【記事】
  // 記事一覧API
  articlesUrl: '/api/v1/articles.json',
  // 記事詳細API
  articleDetailUrl: '/api/v1/articles/_id.json',
  // 記事作成API
  articleCreateUrl: '/api/v1/articles/create.json',
  // 記事編集API
  articleUpdateUrl: '/api/v1/articles/_id/update.json',
  // 記事削除API
  articleDeleteUrl: '/api/v1/articles/_id/delete.json',

  // 【ジャンル】
  // ジャンル一覧API
  genresUrl: '/api/v1/genres.json',
  // ジャンル詳細API
  genreShowUrl: '/api/v1/genres/_id.json',

  // 【お気に入り】
  // お気に入り登録API
  favoriteCreateUrl: '/api/v1/articles/_id/article_favorites/create.json',
  // お気に入り解除API
  favoriteDeleteUrl: '/api/v1/articles/_id/article_favorites/delete.json',

  // 【コメント】
  // コメント一覧API
  commentsUrl: '/api/v1/articles/_article_id/article_comments.json',
  // コメント作成API
  commentCreateUrl: '/api/v1/articles/_article_id/article_comments/create.json',
  // コメント削除API
  commentDeleteUrl: '/api/v1/articles/_article_id/article_comments/_id/delete.json',

  // 【都道府県】
  // 一覧取得API
  prefecturesUrl: '/api/v1/prefectures.json',

  // 【市区町村】
  // 一覧取得API
  setCitiesUrl: '/api/v1/set_cities/_id.json',

  // 【防災タスク】
  // 防災タスク一覧API
  tasksUrl: '/api/v1/tasks.json',
  // 防災タスク詳細API
  taskShowUrl: '/api/v1/tasks/_id.json',

  // 【防災タスク完了】
  // 防災タスク完了API
  completeCreateUrl: '/api/v1/tasks/_id/task_completes/create.json',
  // 防災タスク未完了API
  completeDeleteUrl: '/api/v1/tasks/_id/task_completes/delete.json',

  // 【Maps JavaScript API】
  googleMapApi: process.env.GOOGLE_API_KEY
}
