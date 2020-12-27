class SessionsController < ApplicationController
  skip_before_action :check_is_login, only: [:create]

  def new
  end

  def create
    @t_user = TUser.find_by(email: params[:session][:email].downcase)
    if @t_user && @t_user.authenticate(params[:session][:password])
      log_in @t_user
      session[:user_id] = @t_user.id
      render json: @t_user, status: :ok
    else
      render status: :not_found
    end
  end

  def destroy
    log_out if logged_in?
    render 'new'
  end
end