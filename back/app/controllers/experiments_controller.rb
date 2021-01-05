class ExperimentsController < ApplicationController
  before_action :set_experiment, only: [:show, :update, :destroy]
  wrap_parameters :t_experiment, include: [:name, :data]

  # GET /experiments
  def index
    @t_experiments = TExperiment.order(id: :desc).all

    render json: @t_experiments
  end

  # GET /experiments/search
  def search

    @experiment_result = TExperiment.joins(t_workflows: { t_assessments: :d_assessments } )
      .select("t_experiments.*, t_workflows.*, t_assessments.*, d_assessments.*").order(id: :desc).all

    render json: @experiment_result
  end

  # GET /experiments/1
  def show
    @workflows = TWorkflow.where(t_experiment_id: @t_experiment.id).all

    @works = [] # 各work名の配列
    @work_data = [] # 各workのtデータ配列
    for wf in @workflows do
      @work = MWork.find(wf.m_work_id)
      @works.push @work.name
      
      case @work.name
      when "agreement"
        @t_agreement = TAgreement.find_by(t_workflow_id: wf.id)
        @work_data.push @t_agreement
      when "facesheet"
        @t_facesheet = TFacesheet.find_by(t_workflow_id: wf.id)
        @work_data.push @t_facesheet
      when "assessment"
        @t_assessment = TAssessment.find_by(t_workflow_id: wf.id)
        @work_data.push @t_assessment
      when "questionnaire"
        @t_questionnaire = TQuestionnaire.find_by(t_workflow_id: wf.id)
        @work_data.push @t_questionnaire
      end
    end

    render json: {experiment: @t_experiment, works: @works, work_data: @work_data}
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
          when "facesheet"
            @t_facesheet = TFacesheet.new(
              data[:facesheet].permit!.to_h.merge(
                t_workflow_id: @t_workflow.id
              )
            )
            @t_facesheet.save!
          when "assessment"
            @t_assessment = TAssessment.new(
              t_workflow_id: @t_workflow.id,
              num_files: data[:num_files],
              point: data[:point],
              is_practice: data[:is_practice],
              criteria: data[:criteria]
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
    begin
      ActiveRecord::Base.transaction {
        @t_experiment = TExperiment.find(params[:id])
        @t_experiment.update(name: params[:name])

        for data in params[:data] do

          case data[:work]
          when "agreement"
            @t_agreement = TAgreement.find(data[:id])
            @t_agreement.update(text: data[:text])
          when "facesheet"
            @t_facesheet = TFacesheet.find(data[:id])
            @t_facesheet = TFacesheet.update(
              data[:facesheet].permit!.to_h
            )
          when "assessment"
            @t_assessment = TAssessment.find(data[:id])
            @t_assessment.update(
              num_files: data[:num_files],
              point: data[:point],
              is_practice: data[:is_practice],
              criteria: data[:criteria]
            )
          when "questionnaire"
            @t_questionnaire = TQuestionnaire.find(data[:id])
            @t_questionnaire.update(url: data[:url])
          end
        end
      }
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
