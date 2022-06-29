# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_06_12_135413) do

  create_table "article_comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.bigint "article_id", null: false, comment: "記事ID"
    t.text "content", null: false, comment: "内容"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_article_comments_on_article_id"
    t.index ["user_id"], name: "index_article_comments_on_user_id"
  end

  create_table "article_favorites", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.bigint "article_id", null: false, comment: "記事ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_article_favorites_on_article_id"
    t.index ["user_id", "article_id"], name: "index_article_favorites_on_user_id_and_article_id", unique: true
    t.index ["user_id"], name: "index_article_favorites_on_user_id"
  end

  create_table "article_genre_relations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "article_id", null: false, comment: "記事ID"
    t.bigint "genre_id", null: false, comment: "ジャンルID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_article_genre_relations_on_article_id"
    t.index ["genre_id"], name: "index_article_genre_relations_on_genre_id"
  end

  create_table "articles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.string "title", limit: 30, null: false, comment: "タイトル"
    t.text "content", size: :long, null: false, comment: "内容"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "thumbnail", comment: "サムネイル画像"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "cities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false, comment: "市区町村名"
    t.bigint "prefecture_id", null: false, comment: "都道府県ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["prefecture_id"], name: "index_cities_on_prefecture_id"
  end

  create_table "genres", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 10, null: false, comment: "ジャンル名"
    t.text "image", null: false, comment: "画像"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "infomations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "label", default: 0, null: false, comment: "ラベル"
    t.string "title", comment: "タイトル"
    t.string "summary", comment: "概要"
    t.text "body", comment: "本文"
    t.datetime "started_at", null: false, comment: "開始日時"
    t.datetime "ended_at", comment: "終了日時"
    t.datetime "force_started_at", comment: "強制表示開始日時"
    t.datetime "force_ended_at", comment: "強制表示終了日時"
    t.integer "target", null: false, comment: "対象"
    t.bigint "user_id", comment: "ユーザーID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "action", comment: "アクション"
    t.bigint "action_user_id", comment: "アクションユーザーID"
    t.bigint "article_id", comment: "記事ID"
    t.index ["article_id"], name: "index_infomations_on_article_id"
    t.index ["user_id"], name: "index_infomations_on_user_id"
  end

  create_table "point_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.integer "obtained_point", null: false, comment: "獲得経験値"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_point_records_on_user_id"
  end

  create_table "prefectures", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false, comment: "都道府県名"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_prefectures_on_name", unique: true
  end

  create_table "required_points", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "level", null: false, comment: "レベル"
    t.integer "point", null: false, comment: "次のレベルまでに必要なポイント"
    t.integer "lifelong_point", null: false, comment: "合計獲得ポイント"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "provider", default: "email", null: false, comment: "認証方法"
    t.string "uid", default: "", null: false, comment: "UID"
    t.string "encrypted_password", default: "", null: false, comment: "認証方法"
    t.string "reset_password_token", comment: "パスワードリセットトークン"
    t.datetime "reset_password_sent_at", comment: "パスワードリセット送信日時"
    t.boolean "allow_password_change", default: false, comment: "パスワード再設定中"
    t.datetime "remember_created_at", comment: "ログイン状態維持開始日時"
    t.string "confirmation_token", comment: "メールアドレス確認トークン"
    t.datetime "confirmed_at", comment: "メールアドレス確認日時"
    t.datetime "confirmation_sent_at", comment: "メールアドレス確認送信日時"
    t.string "unconfirmed_email", comment: "確認待ちメールアドレス"
    t.integer "sign_in_count", default: 0, null: false, comment: "ログイン回数"
    t.datetime "current_sign_in_at", comment: "現在のログイン日時"
    t.datetime "last_sign_in_at", comment: "最終ログイン日時"
    t.string "current_sign_in_ip", comment: "現在のログインIPアドレス"
    t.string "last_sign_in_ip", comment: "最終ログインIPアドレス"
    t.integer "failed_attempts", default: 0, null: false, comment: "連続ログイン失敗回数"
    t.string "unlock_token", comment: "アカウントロック解除トークン"
    t.datetime "locked_at", comment: "アカウントロック日時"
    t.string "name", limit: 30, null: false, comment: "氏名"
    t.string "image", comment: "画像"
    t.string "email", default: "", null: false, comment: "メールアドレス"
    t.text "tokens", comment: "認証トークン"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "power", default: 0, null: false, comment: "権限"
    t.datetime "infomation_check_last_started_at", comment: "お知らせ確認最終開始日時"
    t.integer "level", default: 1, null: false, comment: "レベル"
    t.integer "lifelong_point", default: 0, null: false, comment: "合計獲得ポイント"
    t.integer "point_to_next", default: 5, null: false, comment: "現レベルにおける次のレベルまでに必要なポイント"
    t.string "username", limit: 30, null: false, comment: "ユーザーネーム"
    t.text "profile", size: :tiny, comment: "自己紹介文"
    t.integer "prefecture_id", comment: "出身都道府県ID"
    t.integer "city_id", comment: "出身市区町村ID"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "article_comments", "articles"
  add_foreign_key "article_comments", "users"
  add_foreign_key "article_favorites", "articles"
  add_foreign_key "article_favorites", "users"
  add_foreign_key "article_genre_relations", "articles"
  add_foreign_key "article_genre_relations", "genres"
  add_foreign_key "articles", "users"
  add_foreign_key "cities", "prefectures"
  add_foreign_key "infomations", "users"
  add_foreign_key "point_records", "users"
end
