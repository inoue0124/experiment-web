class AddIsSecondTimeToTAssessments < ActiveRecord::Migration[5.2]
  def change
    add_column :t_assessments, :is_second_time, :boolean
  end
end
