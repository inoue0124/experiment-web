class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  wrap_parameters :t_user, include: [:uuid, :email, :password, :password_confirmation]

  # GET /users
  def index
    @t_users = TUser.all

    render json: @t_users
  end

  # GET /users/1
  def show
    render json: @t_user
  end

  # POST /users
  def create
    @t_user = TUser.new(user_params)

    if @t_user.save
      render json: @t_user, status: :created, location: @t_user
    else
      render json: @t_user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @t_user.update(user_params)
      render json: @t_user
    else
      render json: @t_user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @t_user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @t_user = TUser.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:t_user).permit(:uuid, :email, :password, :password_confirmation)
    end
end
