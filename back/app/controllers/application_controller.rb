class ApplicationController < ActionController::API
  include ActionController::Cookies
  include SessionsHelper

  before_action :isAuthenticated
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

    def record_not_found
      render json: { message: "not found" }, status: 404
    end

    # ログイン済みユーザーかどうか確認
    def isAuthenticated
      unless logged_in?
        render json: { message: "unauthorized" }, status: :unauthorized
        return
      end
    end
end
