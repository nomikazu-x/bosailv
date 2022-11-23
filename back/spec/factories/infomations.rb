# == Schema Information
#
# Table name: infomations
#
#  id                                   :bigint           not null, primary key
#  action(アクション)                   :string(255)
#  body(本文)                           :text(65535)
#  ended_at(終了日時)                   :datetime
#  force_ended_at(強制表示終了日時)     :datetime
#  force_started_at(強制表示開始日時)   :datetime
#  label(ラベル)                        :integer          default("Not"), not null
#  started_at(開始日時)                 :datetime         not null
#  summary(概要)                        :string(255)
#  target(対象)                         :integer          not null
#  title(タイトル)                      :string(255)      not null
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  action_user_id(アクションユーザーID) :bigint
#  article_id(記事ID)                   :bigint
#  user_id(ユーザーID)                  :bigint
#
# Indexes
#
#  index_infomations_on_article_id  (article_id)
#  index_infomations_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :infomation do
    label            { :not }
    sequence(:title) { |n| "infomation(#{n})" }
    summary          { "#{title}の要約" }
    body             { "#{title}の本文" }
    started_at       { Time.current - 1.hour }
    ended_at         { Time.current + 3.hour }
    target           { :all }

    # 全員
    trait :all do
      target { :all }
    end

    # 対象ユーザーのみ
    trait :user do
      target { :user }
    end

    # 終了なし
    trait :forever do
      label    { :hindrance }
      ended_at { nil }
    end

    # 終了済み
    trait :finished do
      ended_at { Time.current - 1.second }
    end

    # 予約（終了あり）
    trait :reserve do
      started_at { Time.current + 1.hour }
    end

    # 予約（終了なし）
    trait :reserve_forever do
      started_at { Time.current + 1.hour }
      ended_at { nil }
    end

    # 大切なお知らせ
    trait :important do
      label            { :maintenance }
      force_started_at { Time.current }
      force_ended_at   { Time.current + 2.hour }
    end

    # 大切なお知らせ: 終了なし
    trait :force_forever do
      label          { :other }
      ended_at       { nil }
      force_ended_at { nil }
    end

    # 大切なお知らせ: 終了済み
    trait :force_finished do
      force_ended_at { Time.current - 1.second }
    end

    # 大切なお知らせ: 予約（終了あり）
    trait :force_reserve do
      force_started_at { Time.current + 1.hour }
    end

    # 大切なお知らせ: 予約（終了なし）
    trait :force_reserve_forever do
      force_started_at { Time.current + 1.hour }
      force_ended_at   { nil }
    end
  end
end
