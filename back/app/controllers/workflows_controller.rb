class WorkflowsController < ApplicationController

  # GET /workflow
  def getWork
    @workflow = getCurrentWorkflow
    @work = MWork.find(@workflow.m_work_id)
    
    # 最初のワークフローかどうかをチェック
    @user = current_user
    is_first_workflow = false
    if @user.done_workflow_id.nil?
      # 初回ログイン時は最初のワークフロー
      is_first_workflow = true
    else
      # 現在のワークフローが最初のワークフローかどうかをチェック
      @first_workflow = TWorkflow.order(id: :asc).find_by(t_experiment_id: @user[:t_experiment_id])
      is_first_workflow = (@workflow.id == @first_workflow.id)
    end
    
    render json: {work: @work, workflow: @workflow, is_first_workflow: is_first_workflow}, status: :ok
  end


  # PUT /workflow/:workflow_id/complete
  def complete
    # t_userのdone workflowを次のworkflowに更新する
    @user = current_user
    if @user.update(done_workflow_id: params[:workflow_id])
      getWork
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end


  # PUT /workflow/undo
  def undo
    # t_userのdone workflowを前のworkflowに更新する
    @user = current_user
    @done_wf_id = @user.done_workflow_id
    
    # 最初のワークフローかどうかをチェック
    @first_workflow = TWorkflow.order(id: :asc).find_by(t_experiment_id: @user[:t_experiment_id])
    
    if @done_wf_id == @first_workflow.id
      # 最初のワークフローの場合はnilにして初期状態に戻す
      if @user.update(done_workflow_id: nil)
        getWork
      else
        render json: @user.errors, status: :unprocessable_entity
      end
      return
    end
    
    # done_workflow_idから前のワークフローを見つける
    @prev_wf = TWorkflow.find_by(next_workflow_id: @done_wf_id)

    # 前のワークフローが存在しない場合
    if @prev_wf.nil?
      render json: { error: 'これ以上戻ることはできません' }, status: :unprocessable_entity
      return
    end

    if @user.update(done_workflow_id: @prev_wf.id)
      getWork
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def getWorkMaster
    @work = MWork.all
    render json: @work, status: :ok
  end


  def create
  end


  def destroy
  end
end