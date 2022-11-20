class Api::V1::ApplicationController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token, unless: :format_html?
  prepend_before_action :update_request_uid_header
  before_action :standard_devise_support

  private

  # URLの拡張子がない場合のみ、Device認証を有効にする（APIでCSRFトークン検証をしない為）
  def standard_devise_support
    DeviseTokenAuth.enable_standard_devise_support = format_html?
  end

  protected

  def render_authenticate_error
    if format_html?
      warden.authenticate!({ scope: :user })
    else
      unauthenticated_response
    end
  end
end
