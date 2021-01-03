class FacesheetsController < ApplicationController
  wrap_parameters :d_facesheet, include: [:name, :phone]

  # GET /questionnaires/:workflow_id
  def show
    @t_facesheet = TFacesheet.find_by(t_workflow_id: params[:workflow_id])
    render json: @t_facesheet, status: :ok
  end


  def create
    @user = current_user
    @d_facesheet = DFacesheet.new(d_facesheet_params)
    @d_facesheet[:t_user_id] = @user.id

    if @d_facesheet.save
      render json: @d_facesheet, status: :created
    else
      render json: @d_facesheet.errors, status: :unprocessable_entity
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def d_facesheet_params
      params.require(:d_facesheet).permit(:name, :phone)
    end
end