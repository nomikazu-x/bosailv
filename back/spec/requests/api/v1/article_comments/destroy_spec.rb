require 'rails_helper'

RSpec.describe 'Api::V1::ArticleComments', type: :request do
  # POST /api/v1/articles/:article_id/article_comments/:id/delete(.json) 記事コメント削除API(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  describe 'POST #destroy' do
    subject { post api_v1_destroy_comment_path(article_id: article.id, id: article_comment.id, format: :json), headers: auth_headers }
    let_it_be(:article) { FactoryBot.create(:article) }
    let!(:article_comment) { FactoryBot.create(:article_comment, article: article, user: user) }
    let(:current_user) { user }

    # テスト内容
    shared_examples_for 'OK' do
      it '削除される' do
        expect { subject }.to change(ArticleComment, :count).by(-1)
      end
    end
    shared_examples_for 'NG' do
      it '削除されない' do
        expect { subject }.to change(ArticleComment, :count).by(0)
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
    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    context 'ログイン中' do
      include_context '未ログイン処理'
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like 'OK'
      it_behaves_like 'ToMsg', 200, true, nil, 'notice.article_comment.destroy'
    end
  end
end
