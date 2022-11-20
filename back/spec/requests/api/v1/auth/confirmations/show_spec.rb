require 'rails_helper'

RSpec.describe 'Api::V1::Auth::Confirmations', type: :request do
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

  # GET /api/v1/auth/confirmation メールアドレス確認(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  #   トークン: 期限内, 期限切れ, 存在しない, ない, 空
  #   確認日時: ない（未確認）, 確認送信日時より前（未確認）, 確認送信日時より後（確認済み）
  #   ＋リダイレクトURL: ある, ない, ホワイトリストにない
  describe 'GET #show' do
    subject do
      get auth_confirmation_path(format: :json, confirmation_token: confirmation_token, redirect_url: @redirect_url),
          headers: auth_headers
    end
    let(:current_user) { User.find(send_user.id) }

    # テスト内容
    shared_examples_for 'OK' do
      let!(:start_time) { Time.now.utc.floor }
      it '[リダイレクトURLがある]確認日時が現在日時に変更される' do
        @redirect_url = FRONT_SITE_URL
        subject
        expect(current_user.confirmed_at).to be_between(start_time, Time.now.utc)
      end
      it '[リダイレクトURLがない]確認日時が現在日時に変更される' do
        @redirect_url = nil
        subject
        expect(current_user.confirmed_at).to be_between(start_time, Time.now.utc)
      end
      it '[リダイレクトURLがホワイトリストにない]確認日時が現在日時に変更される' do
        @redirect_url = BAD_SITE_URL
        subject
        expect(current_user.confirmed_at).to be_between(start_time, Time.now.utc)
      end
    end

    shared_examples_for 'NG' do
      it '[リダイレクトURLがある]確認日時が変更されない' do
        @redirect_url = FRONT_SITE_URL
        subject
        expect(current_user.confirmed_at).to eq(send_user.confirmed_at)
      end
      it '[リダイレクトURLがない]確認日時が変更されない' do
        @redirect_url = nil
        subject
        expect(current_user.confirmed_at).to eq(send_user.confirmed_at)
      end
      it '[リダイレクトURLがホワイトリストにない]確認日時が変更されない' do
        @redirect_url = BAD_SITE_URL
        subject
        expect(current_user.confirmed_at).to eq(send_user.confirmed_at)
      end
    end

    shared_examples_for 'ToOK' do |alert, notice|
      it '[リダイレクトURLがある]指定URL（成功パラメータ）にリダイレクトする' do
        @redirect_url = FRONT_SITE_URL
        param = { account_confirmation_success: true }
        param[:alert] = I18n.t(alert) if alert.present?
        param[:notice] = I18n.t(notice) if notice.present?
        is_expected.to redirect_to("#{FRONT_SITE_URL}?#{URI.encode_www_form(param.sort)}")
      end
      it '[リダイレクトURLがない]成功ページにリダイレクトする' do
        @redirect_url = nil
        is_expected.to redirect_to(Settings['confirmation_success_url_not'])
      end
      it '[リダイレクトURLがホワイトリストにない]成功ページにリダイレクトする' do
        @redirect_url = BAD_SITE_URL
        is_expected.to redirect_to(Settings['confirmation_success_url_bad'])
      end
    end

    shared_examples_for 'ToNG' do |alert, notice|
      it '[リダイレクトURLがある]指定URL（失敗パラメータ）にリダイレクトする' do
        @redirect_url = FRONT_SITE_URL
        param = { account_confirmation_success: false }
        param[:alert] = I18n.t(alert) if alert.present?
        param[:notice] = I18n.t(notice) if notice.present?
        is_expected.to redirect_to("#{FRONT_SITE_URL}?#{URI.encode_www_form(param.sort)}")
      end
      it '[リダイレクトURLがない]エラーページにリダイレクトする' do
        @redirect_url = nil
        is_expected.to redirect_to(Settings['confirmation_error_url_not'])
      end
      it '[リダイレクトURLがホワイトリストにない]エラーページにリダイレクトする' do
        @redirect_url = BAD_SITE_URL
        is_expected.to redirect_to(Settings['confirmation_error_url_bad'])
      end
    end

    # テストケース
    shared_examples_for '[未ログイン][期限内]確認日時がない（未確認）' do
      include_context 'メールアドレス確認トークン作成', false, nil
      it_behaves_like 'OK'
      it_behaves_like 'ToOK', nil, 'devise.confirmations.confirmed'
    end

    shared_examples_for '[ログイン中][期限内]確認日時がない（未確認）' do
      include_context 'メールアドレス確認トークン作成', false, nil
      it_behaves_like 'OK'
      it_behaves_like 'ToOK', nil, 'devise.confirmations.confirmed'
    end

    shared_examples_for '[*][期限切れ]確認日時がない（未確認）' do
      include_context 'メールアドレス確認トークン作成', false, nil
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 'activerecord.errors.models.user.attributes.confirmation_token.invalid', nil
    end

    shared_examples_for '[*][存在しない/ない/空]確認日時がない（未確認）' do
      it_behaves_like 'ToNG', 'activerecord.errors.models.user.attributes.confirmation_token.invalid', nil
    end

    shared_examples_for '[未ログイン][期限内]確認日時が確認送信日時より前（未確認）' do
      include_context 'メールアドレス確認トークン作成', true, true
      it_behaves_like 'OK'
      it_behaves_like 'ToOK', nil, 'devise.confirmations.confirmed'
    end

    shared_examples_for '[ログイン中][期限内]確認日時が確認送信日時より前（未確認）' do
      include_context 'メールアドレス確認トークン作成', true, true
      it_behaves_like 'OK'
      it_behaves_like 'ToOK', nil, 'devise.confirmations.confirmed'
    end

    shared_examples_for '[*][期限切れ]確認日時が確認送信日時より前（未確認）' do
      include_context 'メールアドレス確認トークン作成', true, true
      it_behaves_like 'NG'
      it_behaves_like 'ToNG', 'activerecord.errors.models.user.attributes.confirmation_token.invalid', nil
    end

    shared_examples_for '[*][期限内]確認日時が確認送信日時より後（確認済み）' do
      include_context 'メールアドレス確認トークン作成', true, false
      it_behaves_like 'NG'
      it_behaves_like 'ToOK', 'errors.messages.already_confirmed', nil
    end

    shared_examples_for '[*][期限切れ]確認日時が確認送信日時より後（確認済み）' do
      include_context 'メールアドレス確認トークン作成', true, false
      it_behaves_like 'NG'
      it_behaves_like 'ToOK', 'errors.messages.already_confirmed', nil
    end

    shared_examples_for '[未ログイン]トークンが期限内' do
      let_it_be(:confirmation_sent_at) { Time.now.utc }
      it_behaves_like '[未ログイン][期限内]確認日時がない（未確認）'
      it_behaves_like '[未ログイン][期限内]確認日時が確認送信日時より前（未確認）'
      it_behaves_like '[*][期限内]確認日時が確認送信日時より後（確認済み）'
    end

    shared_examples_for '[ログイン中]トークンが期限内' do
      let_it_be(:confirmation_sent_at) { Time.now.utc }
      it_behaves_like '[ログイン中][期限内]確認日時がない（未確認）'
      it_behaves_like '[ログイン中][期限内]確認日時が確認送信日時より前（未確認）'
      it_behaves_like '[*][期限内]確認日時が確認送信日時より後（確認済み）'
    end

    shared_examples_for '[*]トークンが期限切れ' do
      let_it_be(:confirmation_sent_at) { Time.now.utc - User.confirm_within - 1.hour }
      it_behaves_like '[*][期限切れ]確認日時がない（未確認）'
      it_behaves_like '[*][期限切れ]確認日時が確認送信日時より前（未確認）'
      it_behaves_like '[*][期限切れ]確認日時が確認送信日時より後（確認済み）'
    end

    shared_examples_for '[*]トークンが存在しない' do
      let(:confirmation_token) { NOT_TOKEN }
      it_behaves_like '[*][存在しない/ない/空]確認日時がない（未確認）'
    end

    shared_examples_for '[*]トークンがない' do
      let(:confirmation_token) { nil }
      it_behaves_like '[*][存在しない/ない/空]確認日時がない（未確認）'
    end

    shared_examples_for '[*]トークンが空' do
      let(:confirmation_token) { '' }
      it_behaves_like '[*][存在しない/ない/空]確認日時がない（未確認）'
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン]トークンが期限内'
      it_behaves_like '[*]トークンが期限切れ'
      it_behaves_like '[*]トークンが存在しない'
      it_behaves_like '[*]トークンがない'
      it_behaves_like '[*]トークンが空'
    end

    context 'ログイン中' do
      include_context 'ログイン処理'
      it_behaves_like '[ログイン中]トークンが期限内'
      it_behaves_like '[*]トークンが期限切れ'
      it_behaves_like '[*]トークンが存在しない'
      it_behaves_like '[*]トークンがない'
      it_behaves_like '[*]トークンが空'
    end

    context 'APIログイン中' do
      include_context 'APIログイン処理'
      it_behaves_like '[ログイン中]トークンが期限内'
      it_behaves_like '[*]トークンが期限切れ'
      it_behaves_like '[*]トークンが存在しない'
      it_behaves_like '[*]トークンがない'
      it_behaves_like '[*]トークンが空'
    end
  end
end
