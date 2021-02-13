class AddReasonsToDAssessment < ActiveRecord::Migration[5.2]
  def change
    add_column :d_assessments, :reason_first, :string
    add_column :d_assessments, :reason_second, :string
  end
end
