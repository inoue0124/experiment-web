class SessionsController < ApplicationController
  skip_before_action :isAuthenticated, only: [:create]

  def new
    render json: current_user, status: :ok
  end

  def create
    @t_user = TUser.find_by(email: params[:session][:email].downcase)
    
    if @t_user.nil?
      @t_user = TUser.find_by(uuid: params[:session][:email])
    end

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
    render status: :ok
  end
end