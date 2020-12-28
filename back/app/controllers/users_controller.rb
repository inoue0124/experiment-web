class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  wrap_parameters :t_user, include: [:uuid, :email, :password, :password_confirmation]
  skip_before_action :isAuthenticated, only: [:create]

  # GET /users
  def index
    @users = TUser.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = TUser.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :internal_server_error
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = TUser.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:t_user).permit(:uuid, :email, :password, :password_confirmation)
    end
end
