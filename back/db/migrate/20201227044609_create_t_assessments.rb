class CreateTAssessments < ActiveRecord::Migration[5.2]
  def change
    create_table :t_assessments do |t|
      t.references :t_workflow, foreign_key: true
      t.boolean :is_practice
      t.integer :point
      t.integer :num_files
      t.string :criteria

      t.timestamps
    end
  end
end
