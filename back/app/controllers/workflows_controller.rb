class WorkflowsController < ApplicationController

  # GET /workflow
  def getWork
    @workflow = getCurrentWorkflow
    @work = MWork.find(@workflow.m_work_id)
    render json: {work: @work, workflow: @workflow}, status: :ok
  end


  # PUT /workflow/complete
  def complete
    # t_userのdone workflowを次のworkflowに更新する
    @current_wf = getCurrentWorkflow
    if @user.update(done_workflow_id: @current_wf.id)
      getWork
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end


  # PUT /workflow/undo
  def undo
    # t_userのdone workflowを前のworkflowに更新する
    @user = current_user
    @done_wf = TWorkflow.find(@user.done_workflow_id)
    @prev_wf = TWorkflow.find_by(next_workflow_id: @done_wf.id)

    if @user.update(done_workflow_id: @prev_wf.id)
      getWork
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end


  def create
  end


  def destroy
  end
end