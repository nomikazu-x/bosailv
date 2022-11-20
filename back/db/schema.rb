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

ActiveRecord::Schema.define(version: 2022_11_17_122921) do

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

  create_table "emergency_contacts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.string "name", null: false, comment: "連絡先名"
    t.string "phone_number", null: false, comment: "電話番号"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_emergency_contacts_on_user_id"
  end

  create_table "families", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.integer "sex", default: 0, null: false, comment: "性別"
    t.integer "age", default: 0, null: false, comment: "年代"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_families_on_user_id"
  end

  create_table "family_rules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.text "contact_means_memo", null: false, comment: "緊急時連絡手段メモ"
    t.text "refuge_memo", null: false, comment: "避難方法メモ"
    t.text "family_role_memo", null: false, comment: "家族の役割分担メモ"
    t.text "emergency_measure_memo", null: false, comment: "応急処置メモ"
    t.text "leave_home_memo", null: false, comment: "家を離れるときメモ"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_family_rules_on_user_id"
  end

  create_table "genres", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 10, null: false, comment: "ジャンル名"
    t.text "image", null: false, comment: "画像"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description", null: false, comment: "説明文"
    t.string "icon", null: false, comment: "アイコン"
  end

  create_table "hazard_maps", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "city_id", null: false, comment: "市町村ID"
    t.text "tsunami", comment: "津波ハザードマップURL"
    t.text "flood", comment: "洪水ハザードマップURL"
    t.text "landslide", comment: "土砂災害ハザードマップURL"
    t.text "inland_flood", comment: "内水氾濫ハザードマップURL"
    t.text "storm_surge", comment: "高潮ハザードマップURL"
    t.text "volcano", comment: "火山ハザードマップURL"
    t.text "reservoir", comment: "ため池ハザードマップURL"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city_id"], name: "index_hazard_maps_on_city_id"
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

  create_table "shelter_registrations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.bigint "shelter_id", null: false, comment: "避難所ID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shelter_id"], name: "index_shelter_registrations_on_shelter_id"
    t.index ["user_id", "shelter_id"], name: "index_shelter_registrations_on_user_id_and_shelter_id", unique: true
    t.index ["user_id"], name: "index_shelter_registrations_on_user_id"
  end

  create_table "shelters", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "city_id", null: false, comment: "市町村ID"
    t.string "city_name", null: false, comment: "市町村名"
    t.string "name", null: false, comment: "施設・場所名"
    t.string "address", null: false, comment: "住所"
    t.boolean "flood", default: false, null: false, comment: "洪水"
    t.boolean "landslide", default: false, null: false, comment: "土砂"
    t.boolean "storm_surge", default: false, null: false, comment: "高潮"
    t.boolean "earthquake", default: false, null: false, comment: "地震"
    t.boolean "tsunami", default: false, null: false, comment: "津波"
    t.boolean "fire", default: false, null: false, comment: "火事"
    t.boolean "inland_flood", default: false, null: false, comment: "内水氾濫"
    t.boolean "volcano", default: false, null: false, comment: "火山"
    t.boolean "duplicate", default: false, null: false, comment: "指定避難所との重複"
    t.decimal "latitude", precision: 14, scale: 12, null: false, comment: "緯度"
    t.decimal "longitude", precision: 15, scale: 12, null: false, comment: "経度"
    t.string "remark", comment: "備考"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["city_id"], name: "index_shelters_on_city_id"
  end

  create_table "task_completes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.bigint "task_id", null: false, comment: "防災タスクID"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["task_id"], name: "index_task_completes_on_task_id"
    t.index ["user_id", "task_id"], name: "index_task_completes_on_user_id_and_task_id", unique: true
    t.index ["user_id"], name: "index_task_completes_on_user_id"
  end

  create_table "task_profiles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.bigint "sns_tasks", default: 0, null: false, comment: "SNS関係防災タスク"
    t.bigint "house_tasks", default: 0, null: false, comment: "家庭関係防災タスク"
    t.bigint "stock_tasks", default: 0, null: false, comment: "備蓄関係防災タスク"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "hazard_map_confirmed_at", comment: "ハザードマップ確認日時"
    t.index ["user_id"], name: "index_task_profiles_on_user_id"
  end

  create_table "tasks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "image", null: false, comment: "画像"
    t.string "title", limit: 30, null: false, comment: "タイトル"
    t.string "summary", limit: 50, null: false, comment: "概要"
    t.text "body", size: :long, null: false, comment: "本文"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "icon", null: false, comment: "アイコン"
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
    t.datetime "infomation_check_last_started_at", comment: "お知らせ確認最終開始日時"
    t.integer "level", default: 1, null: false, comment: "レベル"
    t.integer "lifelong_point", default: 0, null: false, comment: "合計獲得ポイント"
    t.integer "point_to_next", default: 5, null: false, comment: "現レベルにおける次のレベルまでに必要なポイント"
    t.string "username", limit: 30, null: false, comment: "ユーザーネーム"
    t.text "profile", size: :tiny, comment: "自己紹介文"
    t.integer "prefecture_id", comment: "出身都道府県ID"
    t.bigint "city_id", comment: "出身市区町村ID"
    t.boolean "is_admin", default: false, null: false, comment: "管理者フラグ"
    t.datetime "destroy_schedule_at", comment: "削除予定日時"
    t.string "code", null: false, comment: "コード"
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
  add_foreign_key "emergency_contacts", "users"
  add_foreign_key "families", "users"
  add_foreign_key "family_rules", "users"
  add_foreign_key "hazard_maps", "cities"
  add_foreign_key "infomations", "users"
  add_foreign_key "point_records", "users"
  add_foreign_key "shelter_registrations", "shelters"
  add_foreign_key "shelter_registrations", "users"
  add_foreign_key "shelters", "cities"
  add_foreign_key "task_completes", "tasks"
  add_foreign_key "task_completes", "users"
  add_foreign_key "task_profiles", "users"
end
