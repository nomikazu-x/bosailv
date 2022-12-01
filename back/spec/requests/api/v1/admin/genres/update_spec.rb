require 'rails_helper'

RSpec.describe 'Api::V1::Admin::Genres', type: :request do
  # POST /api/v1/admin/genres/:id/update (.json) ジャンル更新API(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中, 管理者APIログイン中
  #   無効なパラメータ, 有効なパラメータ
  describe 'POST #update' do
    subject { post api_v1_admin_update_genre_path(id: genre.id, format: :json), params: attributes, headers: auth_headers }
    let_it_be(:genre) { FactoryBot.create(:genre) }
    let(:valid_attributes) { { genre: { name: genre[:name], image: genre[:image], description: genre[:description], icon: genre[:icon] } } }
    let(:invalid_attributes) { { genre: { name: nil, image: nil, description: nil, icon: nil } } }

    # テスト内容
    shared_examples_for 'OK' do
      it '更新される。' do
        expect do
          subject
          target_genre = Genre.find(genre.id)
          expect(target_genre.name).to eq(attributes[:name])
          expect(target_genre.image).to eq(attributes[:image])
          expect(target_genre.description).to eq(attributes[:description])
          expect(target_genre.icon).to eq(attributes[:icon])
        end
      end
    end

    shared_examples_for 'NG' do
      it '更新されない。' do
        expect do
          subject
          target_genre = Genre.find(genre.id)
          expect(target_genre.name).to eq(genre.name)
          expect(target_genre.image).to eq(genre.image)
          expect(target_genre.description).to eq(genre.description)
          expect(target_genre.icon).to eq(genre.icon)
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
      it_behaves_like 'ToMsg', 401, false, 'errors.messages.not_permission', nil
    end

    shared_examples_for '[管理者APIログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 422, false, 'alert.genre.update', nil
    end

    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    shared_examples_for '[APIログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'errors.messages.not_permission', nil
    end

    shared_examples_for '[管理者APIログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'OK'
      it_behaves_like 'ToMsg', 200, true, nil, 'notice.genre.update'
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

    context '管理者APIログイン中' do
      include_context 'APIログイン処理', :admin
      it_behaves_like '[管理者APIログイン中]無効なパラメータ'
      it_behaves_like '[管理者APIログイン中]有効なパラメータ'
    end
  end
end
