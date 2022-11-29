require 'rails_helper'

RSpec.describe 'Api::V1::ArticleComments', type: :request do
  # GET /api/v1/articles/:article_id/article_comments(.json) 記事コメント一覧API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  describe 'GET #show' do
    subject { get api_v1_comments_path(article_id: article.id, format: :json), headers: auth_headers }

    shared_context '記事コメント一覧作成' do
      let_it_be(:current_user) { FactoryBot.create(:user) }
      let_it_be(:article) { FactoryBot.create(:article, user_id: user.id) }
      let_it_be(:article_comments) { FactoryBot.create_list(:article_comment, Settings['default_index_limit'], user_id: current_user.id, article_id: article.id) }
    end

    # テスト内容
    shared_examples_for 'ToOK' do
      it 'HTTPステータスが200。件数・対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)

        response_json = JSON.parse(response.body)['comments']

        all = Settings['default_index_limit']
        expect(response_json.count).to eq(all)
        (1..all).each do |no|
          data = response_json[no - 1]
          article_comment = article_comments[no - 1]
          expect(data['id']).to eq(article_comment.id)
          expect(data['content']).to eq(article_comment.content)
          expect(data['created_at']).to eq(I18n.l(article_comment.created_at, format: :json))

          expect(data['user']['id']).to eq(article_comment.user.id)
          expect(data['user']['name']).to eq(article_comment.user.name)
          expect(data['user']['username']).to eq(article_comment.user.username)
          expect(data['user']['image_url']['mini']).to eq("#{article_comment.user.image_url(:mini)}")
          expect(data['user']['image_url']['small']).to eq("#{article_comment.user.image_url(:small)}")
          expect(data['user']['image_url']['medium']).to eq("#{article_comment.user.image_url(:medium)}")
          expect(data['user']['image_url']['large']).to eq("#{article_comment.user.image_url(:large)}")
          expect(data['user']['image_url']['xlarge']).to eq("#{article_comment.user.image_url(:xlarge)}")
        end
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
      include_context '記事コメント一覧作成'
      it_behaves_like 'ToOK'
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      include_context '記事コメント一覧作成'
      it_behaves_like 'ToOK'
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      include_context '記事コメント一覧作成'
      it_behaves_like 'ToOK'
    end
  end
end
