require 'rails_helper'

RSpec.describe 'Api::V1::Shelters', type: :request do
  # GET /api/v1/shelters(.json) 避難所一覧API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン/ログイン中, ログイン中, APIログイン中
  #   有効なパラメータ, 無効なパラメータ
  #   避難所: ない, 最大表示数と同じ, 最大表示数より多い
  describe 'GET #index' do
    subject { get api_v1_shelters_path(page: subject_page, format: :json), params: attributes, headers: auth_headers }
    let(:valid_attributes) { { prefecture_id: prefecture.id, city_id: city.id } }
    let(:invalid_attributes) { { prefecture_id: prefecture.id, city_id: nil } }

    shared_context '都道府県・市町村作成' do
      let_it_be(:prefecture) { FactoryBot.create(:prefecture) }
      let_it_be(:city) { FactoryBot.create(:city, prefecture_id: prefecture.id) }
    end

    # テスト内容
    shared_examples_for 'ToOK' do |page|
      let(:subject_page) { page }
      it 'HTTPステータスが200。対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)

        response_json = JSON.parse(response.body)['shelter']
        expect(response_json['city_name']).to eq(prefecture.name + city.name)
        expect(response_json['total_count']).to eq(shelters.count)
        expect(response_json['current_page']).to eq(subject_page)
        expect(response_json['total_pages']).to eq((shelters.count - 1).div(Settings['default_shelters_limit']) + 1)
        expect(response_json['limit_value']).to eq(Settings['default_shelters_limit'])
      end
    end
    shared_examples_for 'ToNG' do |page, code, success, alert, notice|
      let(:subject_page) { page }
      it "HTTPステータスが#{code}。対象項目が一致する" do
        is_expected.to eq(code)
        response_json = response.body.present? ? JSON.parse(response.body) : {}
        expect(response_json['success']).to eq(success)

        expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
        expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
      end
    end

    shared_examples_for 'リスト表示' do |page|
      let(:subject_page) { page }
      let(:start_no)     { (Settings['default_shelters_limit'] * (page - 1)) + 1 }
      let(:end_no)       { [shelters.count, Settings['default_shelters_limit'] * page].min }
      it '件数・対象項目が一致する' do
        subject
        response_json = JSON.parse(response.body)['shelters']
        expect(response_json.count).to eq(end_no - start_no + 1)
        (start_no..end_no).each do |no|
          data = response_json[no - start_no]
          shelter = shelters[shelters.count - no]
          expect(data['id']).to eq(shelter.id)
          expect(data['name']).to eq(shelter.name)
          expect(data['address']).to eq(shelter.address)
          expect(data['flood']).to eq(shelter.flood)
          expect(data['landslide']).to eq(shelter.landslide)
          expect(data['storm_surge']).to eq(shelter.storm_surge)
          expect(data['earthquake']).to eq(shelter.earthquake)
          expect(data['tsunami']).to eq(shelter.tsunami)
          expect(data['fire']).to eq(shelter.fire)
          expect(data['inland_flood']).to eq(shelter.inland_flood)
          expect(data['volcano']).to eq(shelter.volcano)
          expect(data['duplicate']).to eq(shelter.duplicate)
          # expect(data['latitude']).to eq(shelter.latitude)
          # expect(data['longitude']).to eq(shelter.longitude)
          expect(data['remark']).to eq(shelter.remark)
        end
      end
    end

    # テストケース
    shared_examples_for '[*]避難所がない' do
      include_context '避難所一覧作成', 0, 0
      it_behaves_like 'ToOK', 1
    end
    shared_examples_for '[未ログイン/ログイン中]避難所が最大表示数と同じ' do
      include_context '避難所一覧作成', Settings['default_shelters_limit'], 0
      it_behaves_like 'ToOK', 1
      it_behaves_like 'リスト表示', 1
    end
    shared_examples_for '[APIログイン中]避難所が最大表示数と同じ' do
      include_context '避難所一覧作成', Settings['default_shelters_limit'], 0
      it_behaves_like 'ToOK', 1
      it_behaves_like 'リスト表示', 1
    end
    shared_examples_for '[未ログイン/ログイン中]避難所が最大表示数より多い' do
      include_context '避難所一覧作成', Settings['default_shelters_limit'] + 1, 0
      it_behaves_like 'ToOK', 1
      it_behaves_like 'ToOK', 2
      it_behaves_like 'リスト表示', 1
      it_behaves_like 'リスト表示', 2
    end
    shared_examples_for '[APIログイン中]避難所が最大表示数より多い' do
      include_context '避難所一覧作成', Settings['default_shelters_limit'] + 1, 0
      it_behaves_like 'ToOK', 1
      it_behaves_like 'ToOK', 2
      it_behaves_like 'リスト表示', 1
      it_behaves_like 'リスト表示', 2
    end

    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like '[*]避難所がない'
      it_behaves_like '[未ログイン/ログイン中]避難所が最大表示数と同じ'
      it_behaves_like '[未ログイン/ログイン中]避難所が最大表示数より多い'
    end
    shared_examples_for '[APIログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like '[*]避難所がない'
      it_behaves_like '[APIログイン中]避難所が最大表示数と同じ'
      it_behaves_like '[APIログイン中]避難所が最大表示数より多い'
    end
    shared_examples_for '[未ログイン/ログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'ToNG', 1, 422, false, 'errors.messages.validate_params', nil
    end
    shared_examples_for '[APIログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'ToNG', 1, 422, false, 'errors.messages.validate_params', nil
    end

    context '未ログイン' do
      let(:shelters) { @all_shelters }
      include_context '都道府県・市町村作成'
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
    end
    context 'ログイン中' do
      let(:shelters) { @all_shelters }
      include_context '都道府県・市町村作成'
      include_context 'ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
    end
    context 'APIログイン中' do
      let(:shelters) { @all_shelters }
      include_context '都道府県・市町村作成'
      include_context 'APIログイン処理'
      it_behaves_like '[APIログイン中]有効なパラメータ'
      it_behaves_like '[APIログイン中]無効なパラメータ'
    end
  end
end
