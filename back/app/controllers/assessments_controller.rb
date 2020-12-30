class AssessmentsController < ApplicationController

  def getAssessmentWork
    @user = current_user
    @t_assessment = TAssessment.find_by(t_workflow_id: params[:workflow_id])
    @d_assessments = DAssessment.where(t_assessment_id: @t_assessment.id).where(t_user_id: @user.id)

    @res = []
    for file_num in 1..@t_assessment.num_files do
      
      if @d_assessments.where(file_number: file_num).exists?

        @data = @d_assessments.find_by(file_number: file_num).attributes
        @data[:url] = "https://example.com/"+file_num.to_s
      else
        @data = {t_assessment_id: @t_assessment.id, t_user_id: @user.id, file_number: file_num, url: "https://example.com/"+file_num.to_s, score: 0, comment: ''}
      end

      @res.push @data
    end

    render json: @res, status: :ok
  end


  def update
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

end