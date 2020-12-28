class WorkflowsController < ApplicationController

  # GET /workflow
  def getWork
    @user = current_user

    @done_wf = TWorkflow.find(@user.done_workflow_id)
    @workflow = TWorkflow.find(@done_wf.next_workflow_id)
    @work = MWork.find(@workflow.m_work_id)

    render json: @work, status: :ok
  end


  # PUT /workflow/complete
  def complete
    # t_userのdone workflowを次のworkflowに更新する
    @user = current_user
    
    @done_wf = TWorkflow.find(@user.done_workflow_id)
    @current_wf = TWorkflow.find(@done_wf.next_workflow_id)

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

    getWork
  end


  def create
  end


  def destroy
  end
end