class TExperiment < ApplicationRecord
  has_many :t_workflows, dependent: :destroy
end
