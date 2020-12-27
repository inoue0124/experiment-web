class ApplicationController < ActionController::API
  include ActionController::Cookies
  include SessionsHelper
  before_action :check_is_login

  private
   # ログイン済みユーザーかどうか確認
    def check_is_login
      unless logged_in?
        render json: { message: "unauthorized" }, status: :unauthorized
        return
      end
    end
end
