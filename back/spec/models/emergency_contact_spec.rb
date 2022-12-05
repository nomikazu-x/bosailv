# == Schema Information
#
# Table name: emergency_contacts
#
#  id                     :bigint           not null, primary key
#  name(連絡先名)         :string(255)      not null
#  phone_number(電話番号) :string(255)      not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_id(ユーザーID)    :bigint           not null
#
# Indexes
#
#  index_emergency_contacts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe EmergencyContact, type: :model do
  # テスト内容（共通）
  shared_examples_for 'Valid' do
    it '保存できる' do
      expect(emergency_contact).to be_valid
    end
  end
  shared_examples_for 'InValid' do
    it '保存できない' do
      expect(emergency_contact).to be_invalid
    end
  end

  # 連絡先名
  # 前提条件
  #   なし
  # テストパターン
  #   ない, 最大文字数と同じ, 最大文字数よりも多い
  describe 'validates :name' do
    let(:emergency_contact) { FactoryBot.build_stubbed(:emergency_contact, name: name) }

    # テストケース
    context 'ない' do
      let(:name) { nil }
      it_behaves_like 'InValid'
    end
    context '最大文字数と同じ' do
      let(:name) { 'a' * Settings['emergency_contact_name_maximum'] }
      it_behaves_like 'Valid'
    end
    context '最大文字数よりも多い' do
      let(:name) { 'a' * (Settings['emergency_contact_name_maximum'] + 1) }
      it_behaves_like 'InValid'
    end
  end

  # 電話番号
  # 前提条件
  #   なし
  # テストパターン
  #   ない, 正規表現に一致していない, 正規表現に一致している
  describe 'validates :phone_number' do
    let(:emergency_contact) { FactoryBot.build_stubbed(:emergency_contact, phone_number: phone_number) }

    # テストケース
    context 'ない' do
      let(:phone_number) { nil }
      it_behaves_like 'InValid'
    end
    context '正規表現に一致していない' do
      let(:phone_number) { '123456789' }
      it_behaves_like 'InValid'
    end
    context '正規表現に一致している' do
      let(:phone_number) { '090-1234-5678' }
      it_behaves_like 'Valid'
    end
  end
end
