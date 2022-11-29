require 'rails_helper'

RSpec.describe 'Api::V1::Shelters', type: :request do
  # GET /api/v1/shelter(.json) 避難所詳細API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  describe 'GET #show' do
    subject { get api_v1_shelter_path(id: shelter.id, format: :json), headers: auth_headers }

    shared_context '避難所作成' do
      let_it_be(:current_user) { FactoryBot.create(:user) }
      let_it_be(:shelter) { FactoryBot.create(:shelter) }
    end

    # テスト内容
    shared_examples_for 'ToOK' do
      it 'HTTPステータスが200。対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)

        response_json = JSON.parse(response.body)['shelter']

        expect(response_json['id']).to eq(shelter.id)
        expect(response_json['name']).to eq(shelter.name)
        expect(response_json['address']).to eq(shelter.address)
        expect(response_json['flood']).to eq(shelter.flood)
        expect(response_json['landslide']).to eq(shelter.landslide)
        expect(response_json['storm_surge']).to eq(shelter.storm_surge)
        expect(response_json['earthquake']).to eq(shelter.earthquake)
        expect(response_json['tsunami']).to eq(shelter.tsunami)
        expect(response_json['fire']).to eq(shelter.fire)
        expect(response_json['inland_flood']).to eq(shelter.inland_flood)
        expect(response_json['volcano']).to eq(shelter.volcano)
        expect(response_json['duplicate']).to eq(shelter.duplicate)
        # expect(response_json['latitude']).to eq(shelter.latitude)
        # expect(response_json['longitude']).to eq(shelter.longitude)
        expect(response_json['remark']).to eq(shelter.remark)
        expect(response_json['is_registered']).to eq(auth_headers.present? ? current_user&.shelter_registerd?(shelter) : nil)
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
      include_context '避難所作成'
      it_behaves_like 'ToOK'
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      include_context '避難所作成'
      it_behaves_like 'ToOK'
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      include_context '避難所作成'
      it_behaves_like 'ToOK'
    end
  end
end
