class TFacesheet < ApplicationRecord
  belongs_to :t_workflow
  has_many :d_facesheets, dependent: :destroy
end
