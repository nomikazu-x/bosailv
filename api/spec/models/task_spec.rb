# == Schema Information
#
# Table name: tasks
#
#  id              :bigint           not null, primary key
#  body(本文)      :text(4294967295) not null
#  summary(概要)   :string(50)       not null
#  title(タイトル) :string(30)       not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe Task, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
