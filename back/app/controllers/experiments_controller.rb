class ExperimentsController < ApplicationController
  before_action :set_experiment, only: [:show, :update, :destroy]
  wrap_parameters :t_experiment, include: [:name, :data]

  # GET /experiments
  def index
    @t_experiments = TExperiment.all

    render json: @t_experiments
  end

  # GET /experiments/1
  def show
    render json: @t_experiment
  end

  # POST /experiments
  def create
    begin
      ActiveRecord::Base.transaction {
        @t_experiment = TExperiment.new(
          name: params[:name]
        )
        @t_experiment.save!

        for data in params[:data] do
          @m_work = MWork.find_by(name: data[:work])
          @prev_wf = TWorkflow.where(t_experiment_id: @t_experiment.id).order(created_at: :desc).limit(1)[0]

          @t_workflow = TWorkflow.new(
            t_experiment_id: @t_experiment.id,
            m_work_id: @m_work.id,
            next_workflow_id: 0
          )
          @t_workflow.save!

          # １つ前のworkflowに作成したworkflowのidを入れる
          if !@prev_wf.nil?
            @prev_wf.update(next_workflow_id: @t_workflow.id)
          end

          case data[:work]
          when "agreement"
            @t_agreement = TAgreement.new(
              t_workflow_id: @t_workflow.id,
              text: data[:text]
            )
            @t_agreement.save!
          # when "facesheet" #　後で実装
          when "assessment"
            @t_assessment = TAssessment.new(
              t_workflow_id: @t_workflow.id,
              num_files: data[:num_files]
            )
            @t_assessment.save!
          when "questionnaire"
            @t_questionnaire = TQuestionnaire.new(
              t_workflow_id: @t_workflow.id,
              url: data[:url]
            )
            @t_questionnaire.save!
          end
        end
      }
    end
  end

  # PATCH/PUT /experiments/1
  def update
    if @t_experiment.update(t_experiment_params)
      render json: @t_experiment
    else
      render json: @t_experiment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /experiments/1
  def destroy
    @t_experiment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_experiment
      @t_experiment = TExperiment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def t_experiment_params
      params.require(:t_experiment).permit(:name, :data)
    end
end
