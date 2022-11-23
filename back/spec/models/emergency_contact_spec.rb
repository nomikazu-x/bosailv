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
  describe "correct_emergency_contact" do
    let(:user) { create(:user) }
    let(:emergency_contact) { build(:emergency_contact, user: user) }

    it "緊急時連絡先が正しく作成されていること" do
      expect(emergency_contact).to be_valid
    end
  end

  describe "validate presence" do
    context "nameがNULLの時" do
      let(:emergency_contact) { build(:emergency_contact, name: nil) }
      it "エラーメッセージが返る" do
        emergency_contact.valid?
        expect(emergency_contact).to be_invalid
      end
    end

    context "phone_numberがNULLの時" do
      let(:emergency_contact) { build(:emergency_contact, phone_number: nil) }
      it "エラーメッセージが返る" do
        emergency_contact.valid?
        expect(emergency_contact).to be_invalid
      end
    end

    context "userがNULLの時" do
      let(:emergency_contact) { build(:emergency_contact, user: nil) }
      it "エラーメッセージが返る" do
        emergency_contact.valid?
        expect(emergency_contact).to be_invalid
      end
    end
  end

  describe "association" do
    it "Userテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:user)
      expect(rel.macro).to eq :belongs_to
    end
  end
end
