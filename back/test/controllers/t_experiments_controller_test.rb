require 'test_helper'

class TExperimentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @t_experiment = t_experiments(:one)
  end

  test "should get index" do
    get t_experiments_url, as: :json
    assert_response :success
  end

  test "should create t_experiment" do
    assert_difference('TExperiment.count') do
      post t_experiments_url, params: { t_experiment: { name: @t_experiment.name } }, as: :json
    end

    assert_response 201
  end

  test "should show t_experiment" do
    get t_experiment_url(@t_experiment), as: :json
    assert_response :success
  end

  test "should update t_experiment" do
    patch t_experiment_url(@t_experiment), params: { t_experiment: { name: @t_experiment.name } }, as: :json
    assert_response 200
  end

  test "should destroy t_experiment" do
    assert_difference('TExperiment.count', -1) do
      delete t_experiment_url(@t_experiment), as: :json
    end

    assert_response 204
  end
end
