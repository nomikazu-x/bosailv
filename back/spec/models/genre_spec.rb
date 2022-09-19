# == Schema Information
#
# Table name: genres
#
#  id                  :bigint           not null, primary key
#  description(説明文) :text(65535)      not null
#  image(画像)         :text(65535)      not null
#  name(ジャンル名)    :string(10)       not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe "correct_genre" do
    let(:genre) { build(:genre) }

    it "ジャンルが正しく作成されていること" do
      expect(genre).to be_valid
    end
  end

  describe "validate length" do
    context "nameの長さが11文字以上の時" do
      let(:genre) { build(:genre, name: 'a' * 11) }
      it "エラーメッセージが返る" do
        genre.valid?
        expect(genre).to be_invalid
      end
    end
  end

  describe "validate presence" do
    context "nameがNULLの時" do
      let(:genre) { build(:genre, name: nil) }
      it "エラーメッセージが返る" do
        genre.valid?
        expect(genre).to be_invalid
      end
    end

    context "imageがNULLの時" do
      let(:genre) { build(:genre, image: nil) }
      it "エラーメッセージが返る" do
        genre.valid?
        expect(genre).to be_invalid
      end
    end

    context "descriptionがNULLの時" do
      let(:genre) { build(:genre, description: nil) }
      it "エラーメッセージが返る" do
        genre.valid?
        expect(genre).to be_invalid
      end
    end
  end

  describe "association" do
    it "genreGenreRelationテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:article_genre_relations)
      expect(rel.macro).to eq :has_many
      expect(rel.options[:dependent]).to eq :destroy
    end

    it "Genreテーブルに正しく紐づいていること" do
      rel = described_class.reflect_on_association(:articles)
      expect(rel.macro).to eq :has_many
      expect(rel.options[:through]).to eq :article_genre_relations
    end
  end
end
