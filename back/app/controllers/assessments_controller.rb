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
        @data = {t_assessment_id: @t_assessment.id, t_user_id: @user.id, file_number: file_num, url: S3_DISCLOSE_ASSESSMENT_URL + params[:workflow_id] + "/" + file_num.to_s + ".wav", score: 0, comment: ''}
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
        if @d[:score] != @d_assessment[:score] || @d[:comment] != @d_assessment[:comment]
          @d_assessment.update(@d.permit(:t_assessment_id, :t_user_id, :file_number, :score, :comment).to_h)
        end

      else
        @new_d_assess << DAssessment.new(@d.permit(:t_assessment_id, :t_user_id, :file_number, :score, :comment).to_h)
      end
    end

    # バルクインサート実行
    DAssessment.import @new_d_assess
  end

  # GET /assessments/search
  def search

    @assessment_result = TExperiment.joins(t_workflows: { t_assessments: :d_assessments } )
      .select("t_experiments.*, t_workflows.*, t_assessments.*, d_assessments.*")

    if params[:t_experiment_id]
      @assessment_result =@assessment_result.where(id: params[:t_experiment_id])
    end

    if params[:t_assessment_id]
      @assessment_result =@assessment_result.where("t_assessment_id=#{params[:t_assessment_id]}")
    end

    if params[:t_user_id]
      @assessment_result =@assessment_result.where("t_user_id=#{params[:t_user_id]}")
    end

    @assessment_result = @assessment_result.order('t_experiment_id ASC').order('t_user_id ASC').order('t_assessment_id ASC').order('file_number ASC').all

    render json: @assessment_result
  end
end