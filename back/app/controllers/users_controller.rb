class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  wrap_parameters :t_user, include: [:uuid, :email, :password, :password_confirmation, :t_experiment_id]
  skip_before_action :isAuthenticated, only: [:create]

  # GET /users
  def index
    @users = TUser.where(user_type: 1).order(id: :desc).all
    @users_h = @users.map{ |user| user.attributes }

    @work = MWork.all

    # 実験名とワーク名を付加する
    for i in 0..@users_h.length-1 do
      p @users_h[i]["t_experiment_id"]
      @experiment = TExperiment.find_by_id(@users_h[i]["t_experiment_id"])
      if @experiment.nil?
        @users_h[i]["experiment_name"] =  nil
      else
        @users_h[i]["experiment_name"] = @experiment[:name]
      end

      @done_wf = TWorkflow.find_by_id(@users_h[i]["done_workflow_id"])
      if @done_wf.nil?
        @users_h[i]["done_workflow_name"] = nil
        next
      end

      @work_name = @work.find_by_id(@done_wf[:m_work_id])[:name]
      if @work_name.nil? 
        @users_h[i]["done_workflow_name"] = nil
        next
      end
      
      case @work_name
      when "agreement"
        @users_h[i]["done_workflow_name"] = "同意"
      when "facesheet"
        @users_h[i]["done_workflow_name"] = "背景情報"
      when "assessment"
        @users_h[i]["done_workflow_name"] = "評価実験"
      when "questionnaire"
        @users_h[i]["done_workflow_name"] = "アンケート"
      when "transfer"
        @users_h[i]["done_workflow_name"] = "振込情報入力"
      end
    end

    render json: @users_h
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

  # POST /users/bulk
  def bulkCreate
    @users = []
    for user in params[:_json] do
      user[:user_type] = 1
      @users << TUser.new(user.permit(:uuid, :email, :password, :password_confirmation, :t_experiment_id, :user_type).to_h)
    end
    TUser.import(@users, on_duplicate_key_update: false)
  end

  # PATCH/PUT /users/1
  def update
    TUser.transaction do
      @user.update(user_params)
      @user.update(done_workflow_id: nil)
    end
    render json: @user
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
      params.require(:t_user).permit(:uuid, :email, :password, :password_confirmation, :t_experiment_id)
    end
end
