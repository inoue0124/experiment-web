class WorkflowsController < ApplicationController

  def getNextWork
    @t_user = current_user
    @done_workflow = TWorkflow.find(@t_user.done_workflow_id)
    @next_workflow = TWorkflow.find(@done_workflow.next_workflow_id)
    @next_work = MWork.find(@next_workflow.m_work_id)
    render json: @next_work, status: :ok
  end

  def complete
    @t_user = current_user
    @done_workflow = TWorkflow.find(@t_user.done_workflow_id)
    @current_workflow = TWorkflow.find(@done_workflow.next_workflow_id)
    @t_user.update(done_workflow_id: @current_workflow.id)
    getNextWork
  end

  def undo
    @t_user = current_user
    @done_workflow = TWorkflow.find(@t_user.done_workflow_id)
    @previous_workflow = TWorkflow.find_by(next_workflow_id: @done_workflow.id)
    @t_user.update(done_workflow_id: @previous_workflow.id)
    getNextWork
  end

  def create
  end

  def destroy
  end
end