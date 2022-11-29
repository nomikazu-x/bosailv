require 'rails_helper'

RSpec.describe 'Api::V1::Articles', type: :request do
  # GET /api/v1/article(.json) 記事詳細API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  describe 'GET #show' do
    subject { get api_v1_article_path(id: article.id, format: :json), headers: auth_headers }

    shared_context '記事作成' do
      let_it_be(:current_user) { FactoryBot.create(:user) }
      let_it_be(:article) { FactoryBot.create(:article, user_id: current_user.id) }
    end

    # テスト内容
    shared_examples_for 'ToOK' do
      it 'HTTPステータスが200。対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)

        response_json = JSON.parse(response.body)['article']

        expect(response_json['id']).to eq(article.id)
        expect(response_json['title']).to eq(article.title)
        expect(response_json['content']).to eq(article.content)
        expect(response_json['thumbnail_url']['large']).to eq("#{article.thumbnail_url(:large)}")
        expect(response_json['thumbnail_url']['xlarge']).to eq("#{article.thumbnail_url(:xlarge)}")
        expect(response_json['thumbnail_url']['xxlarge']).to eq("#{article.thumbnail_url(:xxlarge)}")
        expect(response_json['created_at']).to eq(I18n.l(article.created_at, format: :json))
        expect(response_json['updated_at']).to eq(I18n.l(article.updated_at, format: :json, default: nil))
        expect(response_json['is_favorited']).to eq(auth_headers.present? ? current_user&.article_favorite?(article) : nil)

        expect(response_json['user']['id']).to eq(article.user.id)
        expect(response_json['user']['name']).to eq(article.user.name)
        expect(response_json['user']['username']).to eq(article.user.username)
        expect(response_json['user']['image_url']['mini']).to eq("#{article.user.image_url(:mini)}")
        expect(response_json['user']['image_url']['small']).to eq("#{article.user.image_url(:small)}")
        expect(response_json['user']['image_url']['medium']).to eq("#{article.user.image_url(:medium)}")
        expect(response_json['user']['image_url']['large']).to eq("#{article.user.image_url(:large)}")
        expect(response_json['user']['image_url']['xlarge']).to eq("#{article.user.image_url(:xlarge)}")
      end
    end
    # shared_examples_for 'ToNot' do |success, alert, notice|
    #   it 'HTTPステータスが401。対象項目が一致する' do
    #     is_expected.to eq(401)
    #     response_json = response.body.present? ? JSON.parse(response.body) : {}
    #     expect(response_json['success']).to eq(success)

    #     expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
    #     expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
    #   end
    # end

    # テストケース
    context '未ログイン' do
      include_context '未ログイン処理'
      include_context '記事作成'
      it_behaves_like 'ToOK'
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      include_context '記事作成'
      it_behaves_like 'ToOK'
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      include_context '記事作成'
      it_behaves_like 'ToOK'
    end
  end
end
