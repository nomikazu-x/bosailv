# == Schema Information
#
# Table name: tasks
#
#  id              :bigint           not null, primary key
#  body(本文)      :text(4294967295) not null
#  icon(アイコン)  :string(255)      not null
#  image(画像)     :text(65535)      not null
#  summary(概要)   :string(50)       not null
#  title(タイトル) :string(30)       not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe Task, type: :model do
  # テスト内容（共通）
  shared_examples_for 'Valid' do
    it '保存できる' do
      expect(task).to be_valid
    end
  end
  shared_examples_for 'InValid' do
    it '保存できない' do
      expect(task).to be_invalid
    end
  end

  # タイトル
  # 前提条件
  #   なし
  # テストパターン
  #   ない, 最大文字数と同じ, 最大文字数よりも多い
  describe 'validates :title' do
    let(:task) { FactoryBot.build_stubbed(:task, title: title) }

    # テストケース
    context 'ない' do
      let(:title) { nil }
      it_behaves_like 'InValid'
    end
    context '最大文字数と同じ' do
      let(:title) { 'a' * Settings['task_title_maximum'] }
      it_behaves_like 'Valid'
    end
    context '最大文字数よりも多い' do
      let(:title) { 'a' * (Settings['task_title_maximum'] + 1) }
      it_behaves_like 'InValid'
    end
  end

  # 概要
  # 前提条件
  #   なし
  # テストパターン
  #   ない, ある
  describe 'validates :summary' do
    let(:task) { FactoryBot.build_stubbed(:task, summary: summary) }

    # テストケース
    context 'ない' do
      let(:summary) { nil }
      it_behaves_like 'InValid'
    end
    context '最大文字数と同じ' do
      let(:summary) { 'a' * Settings['task_summary_maximum'] }
      it_behaves_like 'Valid'
    end
    context '最大文字数よりも多い' do
      let(:summary) { 'a' * (Settings['task_summary_maximum'] + 1) }
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
    subject { task.image_url(version) }
    let(:task) { FactoryBot.create(:task, image: image) }

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
      let_it_be(:task)  { FactoryBot.create(:task, image: image) }
      it_behaves_like 'OK', :large, false
      it_behaves_like 'OK', :xlarge, false
      it_behaves_like 'OK', :xxlarge, false
      it_behaves_like 'Not', nil
    end
  end
end
