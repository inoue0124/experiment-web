class AgreementsController < ApplicationController

  # GET /agreements/:workflow_id
  def show
    @t_agreement = TAgreement.find_by(t_workflow_id: params[:workflow_id])
    render json: @t_agreement, status: :ok
  end
end