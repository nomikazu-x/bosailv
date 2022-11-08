# == Schema Information
#
# Table name: shelter_registrations
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  shelter_id(避難所ID) :bigint           not null
#  user_id(ユーザーID)  :bigint           not null
#
# Indexes
#
#  index_shelter_registrations_on_shelter_id              (shelter_id)
#  index_shelter_registrations_on_user_id                 (user_id)
#  index_shelter_registrations_on_user_id_and_shelter_id  (user_id,shelter_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (shelter_id => shelters.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe ShelterRegistration, type: :model do
  describe "correct_shelter_registration" do
    let(:user) { create(:user) }
    let(:shelter) { create(:shelter) }
    let(:shelter_registration) { build(:shelter_registration, user: user, shelter: shelter) }

    it "マイ避難所が正しく登録されていること" do
      expect(shelter_registration).to be_valid
    end
  end

  describe "validate presence" do
    context "userがNULLの時" do
      let(:shelter_registration) { build(:shelter_registration, user: nil) }
      it "エラーメッセージが返る" do
        shelter_registration.valid?
        expect(shelter_registration).to be_invalid
      end
    end

    context "shelterがNULLの時" do
      let(:shelter_registration) { build(:shelter_registration, shelter: nil) }
      it "エラーメッセージが返る" do
        shelter_registration.valid?
        expect(shelter_registration).to be_invalid
      end
    end
  end

  describe "association" do
    it "userテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:user)
      expect(rel.macro).to eq :belongs_to
    end

    it "shleterテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:shelter)
      expect(rel.macro).to eq :belongs_to
    end
  end
end
