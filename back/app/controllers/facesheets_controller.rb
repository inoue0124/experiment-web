class FacesheetsController < ApplicationController
  wrap_parameters :d_facesheet, include: [:name, :email, :gender, :age, :is_student, :department_type, :department_name, :is_opi, :is_teacher, 
  :teaching_years, :teach_speaking_experience, :teach_speaking_years, :is_japan, :country_name, :institute, :other_institute]


  # GET /questionnaires
  def index
    @facesheet_result = TExperiment.joins(t_workflows: { t_facesheets: :d_facesheets } )
      .select("t_experiments.*, t_experiments.name AS t_experiment_name, t_workflows.*, t_facesheets.*, d_facesheets.*").order(id: :desc).all
    render json: @facesheet_result, status: :ok
  end


  # GET /questionnaires/:workflow_id
  def show
    @t_facesheet = TFacesheet.find_by(t_workflow_id: params[:workflow_id])
    render json: @t_facesheet, status: :ok
  end

  def showDFacesheet
    @user = current_user
    @d_facesheet = DFacesheet.where(t_facesheet_id: params[:t_facesheet_id]).where(t_user_id: @user.id).order(updated_at: :desc).limit(1)[0]
    p @d_facesheet
    render json: @d_facesheet, status: :ok
  end


  def create
    @user = current_user
    @t_facesheet = TFacesheet.find_by(t_workflow_id: params[:workflow_id])

    @d_facesheet = DFacesheet.new(d_facesheet_params)
    @d_facesheet[:t_user_id] = @user.id
    @d_facesheet[:t_facesheet_id] = @t_facesheet.id

    if @d_facesheet.save
      render json: @d_facesheet, status: :created
    else
      render json: @d_facesheet.errors, status: :unprocessable_entity
    end
  end

  def update
    @user = current_user
    @t_facesheet = TFacesheet.find_by(t_workflow_id: params[:workflow_id])
    @d_facesheet = DFacesheet.find(params[:id])

    if @d_facesheet.update(d_facesheet_params)
      render json: @d_facesheet, status: :created
    else
      render json: @d_facesheet.errors, status: :unprocessable_entity
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def d_facesheet_params
      params.require(:d_facesheet).permit(:name, :email, :gender, :age, :is_student, :department_type, :department_name, :is_opi, :is_teacher, 
      :teaching_years, :teach_speaking_experience, :teach_speaking_years, :is_japan, :country_name, :institute, :other_institute)
    end
end