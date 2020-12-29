class AssessmentsController < ApplicationController

  def getAssessmentWork
    @t_assessment = TAssessment.find_by(t_workflow_id: params[:workflow_id])
    @d_assessments = DAssessment.where(t_assessment_id: @t_assessment.id)

    @res = []
    for file_num in 1..@t_assessment.num_files do
      
      if @d_assessments.exists?(file_number: file_num)

        @data = @d_assessments.find_by(file_number: file_num).attributes
        @data[:url] = "https://example.com/"+file_num.to_s
      else
        @data = {file_number: file_num, url: "https://example.com/"+file_num.to_s, score: 0}
      end

      @res.push @data
    end

    render json: @res, status: :ok
  end

end