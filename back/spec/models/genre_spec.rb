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
  # テスト内容（共通）
  shared_examples_for 'Valid' do
    it '保存できる' do
      expect(genre).to be_valid
    end
  end
  shared_examples_for 'InValid' do
    it '保存できない' do
      expect(genre).to be_invalid
    end
  end

  # ジャンル名
  # 前提条件
  #   なし
  # テストパターン
  #   ない, 最大文字数と同じ, 最大文字数よりも多い
  describe 'validates :name' do
    let(:genre) { FactoryBot.build_stubbed(:genre, name: name) }

    # テストケース
    context 'ない' do
      let(:name) { nil }
      it_behaves_like 'InValid'
    end
    context '最大文字数と同じ' do
      let(:name) { 'a' * Settings['genre_name_maximum'] }
      it_behaves_like 'Valid'
    end
    context '最大文字数よりも多い' do
      let(:name) { 'a' * (Settings['genre_name_maximum'] + 1) }
      it_behaves_like 'InValid'
    end
  end

  # 説明文
  # 前提条件
  #   なし
  # テストパターン
  #   ない, ある
  describe 'validates :description' do
    let(:genre) { FactoryBot.build_stubbed(:genre, description: description) }

    # テストケース
    context 'ない' do
      let(:description) { nil }
      it_behaves_like 'InValid'
    end
    context '最大文字数と同じ' do
      let(:description) { 'a' * Settings['genre_description_maximum'] }
      it_behaves_like 'Valid'
    end
    context '最大文字数よりも多い' do
      let(:description) { 'a' * (Settings['genre_description_maximum'] + 1) }
      it_behaves_like 'InValid'
    end
  end

  # 画像URLを返却
  # 前提条件
  #   なし
  # テストパターン
  #   画像: ある
  #   large, xlarge, xxlarge, 未定義
  describe '#image_url' do
    subject { genre.image_url(version) }
    let(:genre) { FactoryBot.create(:genre, image: image) }

    # テスト内容
    shared_examples_for 'OK' do |version|
      let(:version) { version }
      it 'デフォルトではないURL' do
        is_expected.not_to be_blank
        is_expected.not_to include('_noimage.jpeg')
      end
    end
    shared_examples_for 'Not' do |version|
      let(:version) { version }
      it 'URLが返却されない' do
        is_expected.to be_blank
      end
    end

    # テストケース
    context '画像がある' do
      let_it_be(:image) { File.new(TEST_IMAGE_FILE) }
      let_it_be(:genre)  { FactoryBot.create(:genre, image: image) }
      it_behaves_like 'OK', :large, false
      it_behaves_like 'OK', :xlarge, false
      it_behaves_like 'OK', :xxlarge, false
      it_behaves_like 'Not', nil
    end
  end
end
