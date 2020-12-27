class SessionsController < ApplicationController

  def new
  end

  def create
    @t_user = TUser.find_by(email: params[:session][:email].downcase)
    if @t_user && @t_user.authenticate(params[:session][:password])
      log_in @t_user
      render json: @t_user
    else
      render status: :not_found
    end
  end

  def destroy
    log_out if logged_in?
    render 'new'
  end
end