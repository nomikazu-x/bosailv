require 'rails_helper'

RSpec.describe 'Api::V1::HazardMaps', type: :request do
  # GET /api/v1/hazard_map(.json) ハザードマップ詳細API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  #   有効なパラメータ(存在する, 存在しない), 無効なパラメータ
  describe 'GET #show' do
    subject { get api_v1_hazard_map_path(format: :json), params: attributes, headers: auth_headers }
    let(:valid_attributes) { { prefecture_id: prefecture.id, city_id: city.id } }
    let(:invalid_attributes) { { prefecture_id: prefecture.id, city_id: nil } }
    let(:invalid_bad_attributes) { { prefecture_id: prefecture.id, city_id: not_city.id } }

    shared_context 'ハザードマップ作成' do
      let_it_be(:prefecture) { FactoryBot.create(:prefecture) }
      let_it_be(:city) { FactoryBot.create(:city, prefecture_id: prefecture.id) }
      let_it_be(:not_city) { FactoryBot.create(:city, prefecture_id: prefecture.id) }
      let_it_be(:hazard_map) { FactoryBot.create(:hazard_map, city_id: city.id) }
    end

    # テスト内容
    shared_examples_for 'ToOK' do
      it 'HTTPステータスが200。対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)

        response_json = JSON.parse(response.body)['hazard_map']
        expect(response_json['id']).to eq(hazard_map.city_id)
        expect(response_json['city_name']).to eq(prefecture.name + city.name)
        expect(response_json['tsunami']).to eq(hazard_map.tsunami)
        expect(response_json['flood']).to eq(hazard_map.flood)
        expect(response_json['landslide']).to eq(hazard_map.landslide)
        expect(response_json['inland_flood']).to eq(hazard_map.inland_flood)
        expect(response_json['storm_surge']).to eq(hazard_map.storm_surge)
        expect(response_json['volcano']).to eq(hazard_map.volcano)
        expect(response_json['reservoir']).to eq(hazard_map.reservoir)
      end
    end
    shared_examples_for 'ToNG' do |code, success, alert, notice|
      it "HTTPステータスが#{code}。対象項目が一致する" do
        is_expected.to eq(code)
        response_json = response.body.present? ? JSON.parse(response.body) : {}
        expect(response_json['success']).to eq(success)

        expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
        expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
      end
    end

    # テストケース
    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ(存在する)' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToOK'
    end
    shared_examples_for '[APIログイン中]有効なパラメータ(存在する)' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'ToOK'
    end
    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ(存在しない)' do
      let(:attributes) { invalid_bad_attributes }
      it_behaves_like 'ToNG', 404, nil, nil, nil
    end
    shared_examples_for '[APIログイン中]有効なパラメータ(存在しない)' do
      let(:attributes) { invalid_bad_attributes }
      it_behaves_like 'ToNG', 404, nil, nil, nil
    end
    shared_examples_for '[未ログイン/ログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'ToNG', 422, false, 'errors.messages.validate_params', nil
    end
    shared_examples_for '[APIログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'ToNG', 422, false, 'errors.messages.validate_params', nil
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      include_context 'ハザードマップ作成'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ(存在する)'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ(存在しない)'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      include_context 'ハザードマップ作成'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ(存在する)'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ(存在しない)'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      include_context 'ハザードマップ作成'
      it_behaves_like '[APIログイン中]有効なパラメータ(存在する)'
      it_behaves_like '[APIログイン中]有効なパラメータ(存在しない)'
      it_behaves_like '[APIログイン中]無効なパラメータ'
    end
  end
end
