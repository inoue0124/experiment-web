class TAssessment < ApplicationRecord
  belongs_to :t_workflow
  has_many :d_assessments, dependent: :destroy
end
