# == Schema Information
#
# Table name: articles
#
#  id                        :bigint           not null, primary key
#  content(内容)             :text(4294967295) not null
#  thumbnail(サムネイル画像) :text(65535)
#  title(タイトル)           :string(30)       not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  user_id(ユーザーID)       :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Article, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
