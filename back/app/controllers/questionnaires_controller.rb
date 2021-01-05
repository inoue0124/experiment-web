class QuestionnairesController < ApplicationController

  # GET /questionnaires/:workflow_id
  def show
    @t_questionnaire = TQuestionnaire.find_by(t_workflow_id: params[:workflow_id])
    @t_questionnaire[:url] = @t_questionnaire[:url].sub('viewform?usp=sf_link', 'viewform?embedded=true')
    render json: @t_questionnaire, status: :ok
  end
end