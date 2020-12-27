class CreateDAssessments < ActiveRecord::Migration[5.2]
  def change
    create_table :d_assessments do |t|
      t.references :t_assessment, foreign_key: true
      t.references :t_user, foreign_key: true
      t.integer :file_number
      t.integer :score
      t.string :comment

      t.timestamps
    end
  end
end
