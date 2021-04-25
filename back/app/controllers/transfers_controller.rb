class TransfersController < ApplicationController

  # GET /transfers/:workflow_id
  def show
    @t_transfer = TTransfer.find_by(t_workflow_id: params[:workflow_id])
    render json: @t_transfer, status: :ok
  end
end