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
require 'rails_helper'

RSpec.describe Infomation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
