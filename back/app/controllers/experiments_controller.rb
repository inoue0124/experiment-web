class ExperimentsController < ApplicationController
  before_action :set_experiment, only: [:show, :update, :destroy]

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
    @t_experiment = TExperiment.new(t_experiment_params)

    if @t_experiment.save
      render json: @t_experiment, status: :created, location: @t_experiment
    else
      render json: @t_experiment.errors, status: :unprocessable_entity
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
      params.require(:t_experiment).permit(:name)
    end
end
