class AssessmentsController < ApplicationController

  def getAssessment
    @t_assessment = TAssessment.find_by(t_workflow_id: params[:workflow_id])
    @instruction_pdf_url = S3_DISCLOSE_ASSESSMENT_URL + params[:workflow_id] + "/instruction.pdf"
    @rubric_pdf_url = S3_DISCLOSE_ASSESSMENT_URL + params[:workflow_id] + "/rubric.pdf"
    @test_url = S3_DISCLOSE_ASSESSMENT_URL + params[:workflow_id] + "/test.mp3"

    render json: {
      t_assessment: @t_assessment,
      instruction_pdf_url: @instruction_pdf_url,
      rubric_pdf_url: @rubric_pdf_url,
      test_url: @test_url
    },
    status: :ok
  end


  def getAssessmentData
    @user = current_user
    @t_assessment = TAssessment.find_by(t_workflow_id: params[:workflow_id])
    @d_assessments = DAssessment.where(t_assessment_id: @t_assessment.id).where(t_user_id: @user.id)

    @res = []
    for file_num in 1..@t_assessment.num_files do
      
      if @d_assessments.where(file_number: file_num).exists?

        @data = @d_assessments.find_by(file_number: file_num).attributes
        @data[:url] = S3_DISCLOSE_ASSESSMENT_URL + params[:workflow_id] + "/" + file_num.to_s + ".wav"
      else
        @data = {t_assessment_id: @t_assessment.id, t_user_id: @user.id, file_number: file_num, url: S3_DISCLOSE_ASSESSMENT_URL + params[:workflow_id] + "/" + file_num.to_s + ".wav", score: 0, comment: '', reason_first: '', reason_second: ''}
      end

      @res.push @data
    end

    render json: @res, status: :ok
  end


  def updateAssessmentData
    @user = current_user
    @t_assessment = TAssessment.find_by(t_workflow_id: params[:workflow_id])
    @d_assessments = DAssessment.where(t_assessment_id: @t_assessment.id).where(t_user_id: @user.id)

    # バルクインサート用配列
    @new_d_assess = []
    for file_num in 1..@t_assessment.num_files do
      @d = params[:_json].find {|data| data[:file_number] == file_num}

      if @d_assessments.exists?(file_number: file_num)
        @d_assessment = @d_assessments.find_by(file_number: file_num)

        # 変更があるデータのみupdate
        if @d[:score] != @d_assessment[:score] || @d[:reason_first] != @d_assessment[:reason_first] || @d[:reason_second] != @d_assessment[:reason_second] || @d[:comment] != @d_assessment[:comment]
          @d_assessment.update(@d.permit(:t_assessment_id, :t_user_id, :file_number, :score, :comment, :reason_first, :reason_second).to_h)
        end

      else
        @new_d_assess << DAssessment.new(@d.permit(:t_assessment_id, :t_user_id, :file_number, :score, :comment, :reason_first, :reason_second).to_h)
      end
    end

    # バルクインサート実行
    DAssessment.import @new_d_assess
  end

  def getPracticeAssessmentData
    @user = current_user
    @current_workflow = TWorkflow.find(params[:workflow_id])
    
    # 同じ実験内の全ワークフローを取得
    @experiment_workflows = TWorkflow.where(t_experiment_id: @current_workflow.t_experiment_id)
                                    .order(id: :asc)
    
    # 現在のワークフローより前の練習モードワークフローを検索
    @practice_workflow = nil
    @experiment_workflows.each do |wf|
      # 現在のワークフローより前のもののみを対象
      if wf.id < @current_workflow.id
        assessment = TAssessment.find_by(t_workflow_id: wf.id)
        if assessment&.is_practice == true
          @practice_workflow = wf
          break # 最初に見つかった練習モードを使用
        end
      end
    end
    
    # 練習ワークフローが見つからない場合は空の配列を返す
    if @practice_workflow.nil?
      render json: { practice_data: [] }, status: :ok
      return
    end
    
    # 練習モードの音声ファイルURLを生成
    @practice_assessment = TAssessment.find_by(t_workflow_id: @practice_workflow.id)
    @practice_samples = []
    
    for file_num in 1..@practice_assessment.num_files do
      @practice_samples << {
        file_number: file_num,
        url: S3_DISCLOSE_ASSESSMENT_URL + @practice_workflow.id.to_s + "/" + file_num.to_s + ".wav"
      }
    end
    
    render json: { practice_data: @practice_samples }, status: :ok
  end

  # GET /assessments/search
  def search

    @assessment_query = TExperiment.joins(t_workflows: { t_assessments: :d_assessments } )

    if params[:t_experiment_id]
      @assessment_query = @assessment_query.where(id: params[:t_experiment_id])
    end

    if params[:t_assessment_id]
      @assessment_query = @assessment_query.where("t_assessment_id=#{params[:t_assessment_id]}")
    end

    if params[:t_user_id]
      @assessment_query = @assessment_query.where("t_user_id=#{params[:t_user_id]}")
    end
    @count = @assessment_query.count
    @exp_ids = @assessment_query.select("t_experiment_id").distinct.map { |e| e.t_experiment_id }.sort
    @assess_ids = @assessment_query.select("t_assessment_id").distinct.map { |e| e.t_assessment_id }.sort
    @user_ids = @assessment_query.select("t_user_id").distinct.map { |e| e.t_user_id }.sort

    if params[:limit].to_i != -1 and params[:limit] and params[:page]
      page = params[:page].to_i
      limit = params[:limit].to_i
      offset = (page - 1) * limit
      @assessment_query = @assessment_query.limit(limit).offset(offset)
    end

    @data = @assessment_query.order('t_experiment_id ASC').order('t_user_id ASC').order('t_assessment_id ASC').order('file_number ASC')
            .select("t_experiments.*, t_workflows.*, t_assessments.*, d_assessments.*").all

    render json: {
      data: @data,
      exp_ids: @exp_ids,
      assess_ids: @assess_ids,
      user_ids: @user_ids,
      count: @count
    }
  end
end