class WorkflowsController < ApplicationController

  def getNextWork
    @t_user = current_user
    render json: @t_user
  end

  def create
  end

  def destroy
  end
end