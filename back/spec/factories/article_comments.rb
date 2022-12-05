# == Schema Information
#
# Table name: article_comments
#
#  id                  :bigint           not null, primary key
#  content(内容)       :text(255)        not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  article_id(記事ID)  :bigint           not null
#  user_id(ユーザーID) :bigint           not null
#
# Indexes
#
#  index_article_comments_on_article_id  (article_id)
#  index_article_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :article_comment do
    association :user
    association :article
    sequence(:content) { |n| "content(#{n})" }
  end
end
