class TWorkflow < ApplicationRecord
  belongs_to :t_experiment
  belongs_to :m_work
  has_many :t_agreements, dependent: :destroy
  has_many :t_facesheets, dependent: :destroy
  has_many :t_assessments, dependent: :destroy
  has_many :t_questionnaires, dependent: :destroy
end
