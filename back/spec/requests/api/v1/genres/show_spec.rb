require 'rails_helper'

RSpec.describe 'Api::V1::Genres', type: :request do
  # GET /api/v1/genres/:id(.json) 記事一覧API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  #   記事: ない, 最大表示数と同じ, 最大表示数より多い
  describe 'GET #show' do
    subject { get api_v1_genre_path(id: @genre.id, page: subject_page, format: :json), headers: auth_headers }

    # テスト内容
    shared_examples_for 'ToOK' do |page|
      let(:subject_page) { page }
      it 'HTTPステータスが200。対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)

        response_json = JSON.parse(response.body)
        expect(response_json['genre']['id']).to eq(@genre.id)
        expect(response_json['genre']['name']).to eq(@genre.name)
        expect(response_json['genre']['description']).to eq(@genre.description)
        expect(response_json['genre']['icon']).to eq(@genre.icon)
        expect(response_json['genre']['image_url']['large']).to eq("#{@genre.image_url(:large)}")
        expect(response_json['genre']['image_url']['xlarge']).to eq("#{@genre.image_url(:xlarge)}")

        expect(response_json['article']['total_count']).to eq(articles.count)
        expect(response_json['article']['current_page']).to eq(subject_page)
        expect(response_json['article']['total_pages']).to eq((articles.count - 1).div(Settings['default_articles_limit']) + 1)
        expect(response_json['article']['limit_value']).to eq(Settings['default_articles_limit'])
      end
    end

    shared_examples_for 'リスト表示' do |page|
      let(:subject_page) { page }
      let(:start_no)     { (Settings['default_articles_limit'] * (page - 1)) + 1 }
      let(:end_no)       { [articles.count, Settings['default_articles_limit'] * page].min }
      it '件数・対象項目が一致する' do
        subject
        response_json = JSON.parse(response.body)['articles']
        expect(response_json.count).to eq(end_no - start_no + 1)
        (start_no..end_no).each do |no|
          data = response_json[no - start_no]
          article = articles[articles.count - no]
          expect(data['id']).to eq(article.id)
          expect(data['title']).to eq(article.title)
          expect(data['content']).to eq(article.content)
          # expect(data['created_at']).to eq(I18n.l(article.created_at, format: :json))
          # expect(data['updated_at']).to eq(I18n.l(article.updated_at, format: :json, default: nil))
          expect(data['thumbnail_url']['large']).to eq("#{article.thumbnail_url(:large)}")
          expect(data['thumbnail_url']['xlarge']).to eq("#{article.thumbnail_url(:xlarge)}")
          expect(data['thumbnail_url']['xxlarge']).to eq("#{article.thumbnail_url(:xxlarge)}")
        end
      end
    end

    # テストケース
    shared_examples_for '[*]記事がない' do
      include_context '記事一覧作成', 0, 0, 0, 0
      it_behaves_like 'ToOK', 1
    end
    shared_examples_for '[未ログイン]記事が最大表示数と同じ' do
      count = Settings['test_articles']
      all = count['genre_exist_count'] + count['genre_none_count'] + count['favorite_exist_count'] + count['favorite_none_count']
      include_context '記事一覧作成', all, 0, 0, 0
      it_behaves_like 'ToOK', 1
      it_behaves_like 'リスト表示', 1
    end
    shared_examples_for '[ログイン中]記事が最大表示数と同じ' do
      count = Settings['test_articles']
      all = count['genre_exist_count'] + count['genre_none_count'] + count['favorite_exist_count'] + count['favorite_none_count']
      include_context '記事一覧作成', all, 0, 0, 0
      it_behaves_like 'ToOK', 1
      it_behaves_like 'リスト表示', 1
    end
    shared_examples_for '[APIログイン中]記事が最大表示数と同じ' do
      count = Settings['test_articles']
      all = count['genre_exist_count'] + count['genre_none_count'] + count['favorite_exist_count'] + count['favorite_none_count']
      include_context '記事一覧作成', all, 0, 0, 0
      it_behaves_like 'ToOK', 1
      it_behaves_like 'リスト表示', 1
    end
    shared_examples_for '[未ログイン]記事が最大表示数より多い' do
      count = Settings['test_articles']
      all = count['genre_exist_count'] + count['genre_none_count'] + count['favorite_exist_count'] + count['favorite_none_count']
      include_context '記事一覧作成', all + 1, 0, 0, 0
      it_behaves_like 'ToOK', 1
      it_behaves_like 'ToOK', 2
      it_behaves_like 'リスト表示', 1
      it_behaves_like 'リスト表示', 2
    end
    shared_examples_for '[ログイン中]記事が最大表示数より多い' do
      count = Settings['test_articles']
      all = count['genre_exist_count'] + count['genre_none_count'] + count['favorite_exist_count'] + count['favorite_none_count']
      include_context '記事一覧作成', all + 1, 0, 0, 0
      it_behaves_like 'ToOK', 1
      it_behaves_like 'ToOK', 2
      it_behaves_like 'リスト表示', 1
      it_behaves_like 'リスト表示', 2
    end
    shared_examples_for '[APIログイン中]記事が最大表示数より多い' do
      count = Settings['test_articles']
      all = count['genre_exist_count'] + count['genre_none_count'] + count['favorite_exist_count'] + count['favorite_none_count']
      include_context '記事一覧作成', all + 1, 0, 0, 0
      it_behaves_like 'ToOK', 1
      it_behaves_like 'ToOK', 2
      it_behaves_like 'リスト表示', 1
      it_behaves_like 'リスト表示', 2
    end

    context '未ログイン' do
      let(:articles) { @all_articles }
      include_context '未ログイン処理'
      it_behaves_like '[*]記事がない'
      it_behaves_like '[未ログイン]記事が最大表示数と同じ'
      it_behaves_like '[未ログイン]記事が最大表示数より多い'
    end
    context 'ログイン中' do
      let(:articles) { @all_articles }
      include_context 'ログイン処理'
      it_behaves_like '[*]記事がない'
      it_behaves_like '[ログイン中]記事が最大表示数と同じ'
      it_behaves_like '[ログイン中]記事が最大表示数より多い'
    end
    context 'APIログイン中' do
      let(:articles) { @all_articles }
      include_context 'APIログイン処理'
      it_behaves_like '[*]記事がない'
      it_behaves_like '[APIログイン中]記事が最大表示数と同じ'
      it_behaves_like '[APIログイン中]記事が最大表示数より多い'
    end
  end
end
