require 'rails_helper'

RSpec.describe 'Api::V1::Articles', type: :request do
  # POST /api/v1/articles/:id/update (.json) 記事更新API(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中, 管理者APIログイン中
  #   無効なパラメータ, 有効なパラメータ
  describe 'POST #update' do
    subject { post api_v1_update_article_path(id: article.id, format: :json), params: attributes, headers: auth_headers }
    let!(:article) { FactoryBot.create(:article, user: user) }
    let(:valid_attributes) { { article: { title: article[:title], content: article[:content], thumbnail: article[:thumbnail] } } }
    let(:invalid_attributes) { { article: { title: nil, content: nil, thumbnail: nil } } }
    let(:current_user) { user }

    # テスト内容
    shared_examples_for 'OK' do
      it '更新される。' do
        expect do
          subject
          target_article = Article.find(article.id)
          expect(target_article.title).to eq(attributes[:title])
          expect(target_article.content).to eq(attributes[:content])
          expect(target_article.thumbnail).to eq(attributes[:thumbnail])
        end
      end
    end

    shared_examples_for 'NG' do
      it '更新されない。' do
        expect do
          subject
          target_article = Article.find(article.id)
          expect(target_article.title).to eq(article.title)
          expect(target_article.content).to eq(article.content)
          expect(target_article.thumbnail).to eq(article.thumbnail)
        end
      end
    end

    shared_examples_for 'ToMsg' do |code, success, alert, notice|
      it "HTTPステータスが#{code}。対象項目が一致する。" do
        is_expected.to eq(code)
        response_json = response.body.present? ? JSON.parse(response.body) : {}
        expect(response_json['success']).to eq(success)

        expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
        expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
      end
    end

    # テストケース
    shared_examples_for '[未ログイン/ログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    shared_examples_for '[APIログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 422, false, 'alert.article.update', nil
    end

    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    shared_examples_for '[APIログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 200, true, nil, 'notice.article.update'
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ'
    end

    context 'ログイン中' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ'
    end

    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like '[APIログイン中]無効なパラメータ'
      it_behaves_like '[APIログイン中]有効なパラメータ'
    end
  end
end
