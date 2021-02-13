class AddReasonToTAssessment < ActiveRecord::Migration[5.2]
  def change
    add_column :t_assessments, :reasons, :string
  end
end
