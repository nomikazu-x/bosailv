require 'rails_helper'

RSpec.describe 'Users::Auth::Unlocks', type: :request do
  # テスト内容（共通）
  shared_examples_for 'ToMsg' do |error_class, errors_count, error_msg, message, alert, notice|
    it '対象のメッセージと一致する' do
      subject
      response_json = JSON.parse(response.body)
      expect(response_json['errors'].to_s).to error_msg.present? ? include(I18n.t(error_msg)) : be_blank
      expect(response_json['errors'].class).to eq(error_class)
      expect(response_json['errors']&.count).to errors_count.positive? ? eq(errors_count) : be_nil

      expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
      expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
    end
  end

  # GET /api/v1/auth/unlock アカウントロック解除(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  #   トークン: 存在する, 存在しない, ない, 空
  #   ロック日時: ない（未ロック）, 期限内（ロック中）, 期限切れ（未ロック）
  #   ＋リダイレクトURL: ある, ない, ホワイトリストにない
  describe 'GET #show' do
    subject do
      get auth_unlock_path(format: :json, unlock_token: unlock_token, redirect_url: @redirect_url), headers: auth_headers
    end
    let(:current_user) { User.find(send_user.id) }

    # テスト内容
    shared_examples_for 'OK' do
      it '[リダイレクトURLがある]アカウントロック日時がなしに回数が0に変更される' do
        @redirect_url = FRONT_SITE_URL
        subject
        expect(current_user.locked_at).to be_nil
        expect(current_user.failed_attempts).to eq(0)
      end
      # it '[リダイレクトURLがない]アカウントロック日時がなしに変更されない' do
      it '[リダイレクトURLがない]アカウントロック日時がなしに回数が0に変更される' do
        @redirect_url = nil
        subject
        # expect(current_user.locked_at).to eq(send_user.locked_at)
        # expect(current_user.failed_attempts).to eq(send_user.failed_attempts)
        expect(current_user.locked_at).to be_nil
        expect(current_user.failed_attempts).to eq(0)
      end
      # it '[リダイレクトURLがホワイトリストにない]アカウントロック日時がなしに変更されない' do
      it '[リダイレクトURLがホワイトリストにない]アカウントロック日時がなしに回数が0に変更される' do
        @redirect_url = BAD_SITE_URL
        subject
        # expect(current_user.locked_at).to eq(send_user.locked_at)
        # expect(current_user.failed_attempts).to eq(send_user.failed_attempts)
        expect(current_user.locked_at).to be_nil
        expect(current_user.failed_attempts).to eq(0)
      end
    end
    shared_examples_for 'NG' do
      it '[リダイレクトURLがある]アカウントロック日時・回数が変更されない' do
        @redirect_url = FRONT_SITE_URL
        subject
        expect(current_user.locked_at).to eq(send_user.locked_at)
        expect(current_user.failed_attempts).to eq(send_user.failed_attempts)
      end
      it '[リダイレクトURLがない]アカウントロック日時・回数が変更されない' do
        @redirect_url = nil
        subject
        expect(current_user.locked_at).to eq(send_user.locked_at)
        expect(current_user.failed_attempts).to eq(send_user.failed_attempts)
      end
      it '[リダイレクトURLがホワイトリストにない]アカウントロック日時・回数が変更されない' do
        @redirect_url = BAD_SITE_URL
        subject
        expect(current_user.locked_at).to eq(send_user.locked_at)
        expect(current_user.failed_attempts).to eq(send_user.failed_attempts)
      end
    end

    shared_examples_for 'ToOK' do |alert, notice|
      it '[リダイレクトURLがある]指定URL（成功パラメータ）にリダイレクトする' do
        @redirect_url = FRONT_SITE_URL
        param = { unlock: true }
        param[:alert] = I18n.t(alert) if alert.present?
        param[:notice] = I18n.t(notice) if notice.present?
        is_expected.to redirect_to("#{FRONT_SITE_URL}?#{URI.encode_www_form(param.sort)}")
      end
      # it '[リダイレクトURLがない]HTTPステータスが422。対象項目が一致する' do
      it '[リダイレクトURLがない]成功ページにリダイレクトする' do
        @redirect_url = nil
        # is_expected.to eq(422)
        # response_json = JSON.parse(response.body)
        # expect(response_json['success']).to eq(false)
        # expect(response_json['errors']).not_to be_nil
        # expect(response_json['message']).to be_nil
        is_expected.to redirect_to(Settings['unlock_success_url_not'])
      end
      # it '[リダイレクトURLがホワイトリストにない]HTTPステータスが422。対象項目が一致する' do
      it '[リダイレクトURLがホワイトリストにない]成功ページにリダイレクトする' do
        @redirect_url = BAD_SITE_URL
        # is_expected.to eq(422)
        # response_json = JSON.parse(response.body)
        # expect(response_json['success']).to eq(false)
        # expect(response_json['errors']).not_to be_nil
        # expect(response_json['message']).to be_nil
        is_expected.to redirect_to(Settings['unlock_success_url_bad'])
      end
    end
    shared_examples_for 'ToNG' do |alert, notice|
      it '[リダイレクトURLがある]指定URL（失敗パラメータ）にリダイレクトする' do
        @redirect_url = FRONT_SITE_URL
        param = { unlock: false }
        param[:alert] = I18n.t(alert) if alert.present?
        param[:notice] = I18n.t(notice) if notice.present?
        is_expected.to redirect_to("#{FRONT_SITE_URL}?#{URI.encode_www_form(param.sort)}")
      end
      # it '[リダイレクトURLがない]HTTPステータスが422。対象項目が一致する' do
      it '[リダイレクトURLがない]エラーページにリダイレクトする' do
        @redirect_url = nil
        # is_expected.to eq(422)
        # response_json = JSON.parse(response.body)
        # expect(response_json['success']).to eq(false)
        # expect(response_json['errors']).not_to be_nil
        # expect(response_json['message']).to be_nil
        is_expected.to redirect_to(Settings['unlock_error_url_not'])
      end
      # it '[リダイレクトURLがホワイトリストにない]HTTPステータスが422。対象項目が一致する' do
      it '[リダイレクトURLがホワイトリストにない]エラーページにリダイレクトする' do
        @redirect_url = BAD_SITE_URL
        # is_expected.to eq(422)
        # response_json = JSON.parse(response.body)
        # expect(response_json['success']).to eq(false)
        # expect(response_json['errors']).not_to be_nil
        # expect(response_json['message']).to be_nil
        is_expected.to redirect_to(Settings['unlock_error_url_bad'])
      end
    end

    # テストケース
    shared_examples_for '[*][存在する]ロック日時がない（未ロック）' do
      include_context 'アカウントロック解除トークン作成', false
      it_behaves_like 'NG'
      # it_behaves_like 'ToOK', nil, nil
      it_behaves_like 'ToOK', nil, 'devise.unlocks.unlocked' # Tips: 既に解除済み
    end
    shared_examples_for '[*][存在しない]ロック日時がない（未ロック）' do
      # it_behaves_like 'NG' # Tips: トークンが存在しない為、ロック日時がない
      # it_behaves_like 'ToNG', nil, nil # Tips: ActionController::RoutingError: Not Found
      it_behaves_like 'ToNG', 'activerecord.errors.models.user.attributes.unlock_token.invalid', nil
    end
    shared_examples_for '[*][ない/空]ロック日時がない（未ロック）' do
      # it_behaves_like 'NG' # Tips: トークンが存在しない為、ロック日時がない
      # it_behaves_like 'ToNG', nil, nil # Tips: ActionController::RoutingError: Not Found
      it_behaves_like 'ToNG', 'activerecord.errors.models.user.attributes.unlock_token.blank', nil
    end
    shared_examples_for '[*][存在する]ロック日時が期限内（ロック中）' do
      include_context 'アカウントロック解除トークン作成', true
      it_behaves_like 'OK'
      it_behaves_like 'ToOK', nil, 'devise.unlocks.unlocked' # Tips: 解除されても良さそう
    end
    shared_examples_for '[*][存在する]ロック日時が期限切れ（未ロック）' do
      include_context 'アカウントロック解除トークン作成', true, true
      it_behaves_like 'OK'
      it_behaves_like 'ToOK', nil, 'devise.unlocks.unlocked'
    end

    shared_examples_for '[*]トークンが存在する' do
      it_behaves_like '[*][存在する]ロック日時がない（未ロック）'
      it_behaves_like '[*][存在する]ロック日時が期限内（ロック中）'
      it_behaves_like '[*][存在する]ロック日時が期限切れ（未ロック）'
    end
    shared_examples_for '[*]トークンが存在しない' do
      let(:unlock_token) { NOT_TOKEN }
      it_behaves_like '[*][存在しない]ロック日時がない（未ロック）'
      # it_behaves_like '[*][存在しない]ロック日時が期限内（ロック中）' # Tips: トークンが存在しない為、ロック日時がない
      # it_behaves_like '[*][存在しない]ロック日時が期限切れ（未ロック）' # Tips: トークンが存在しない為、ロック日時がない
    end
    shared_examples_for '[*]トークンがない' do
      let(:unlock_token) { nil }
      it_behaves_like '[*][ない/空]ロック日時がない（未ロック）'
      # it_behaves_like '[*][ない]ロック日時が期限内（ロック中）' # Tips: トークンが存在しない為、ロック日時がない
      # it_behaves_like '[*][ない]ロック日時が期限切れ（未ロック）' # Tips: トークンが存在しない為、ロック日時がない
    end
    shared_examples_for '[*]トークンが空' do
      let(:unlock_token) { '' }
      it_behaves_like '[*][ない/空]ロック日時がない（未ロック）'
      # it_behaves_like '[*][空]ロック日時が期限内（ロック中）' # Tips: トークンが存在しない為、ロック日時がない
      # it_behaves_like '[*][空]ロック日時が期限切れ（未ロック）' # Tips: トークンが存在しない為、ロック日時がない
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[*]トークンが存在する'
      it_behaves_like '[*]トークンが存在しない'
      it_behaves_like '[*]トークンがない'
      it_behaves_like '[*]トークンが空'
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      it_behaves_like '[*]トークンが存在する'
      it_behaves_like '[*]トークンが存在しない'
      it_behaves_like '[*]トークンがない'
      it_behaves_like '[*]トークンが空'
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like '[*]トークンが存在する'
      it_behaves_like '[*]トークンが存在しない'
      it_behaves_like '[*]トークンがない'
      it_behaves_like '[*]トークンが空'
    end
  end
end