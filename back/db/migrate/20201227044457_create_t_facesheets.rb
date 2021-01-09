class CreateTFacesheets < ActiveRecord::Migration[5.2]
  def change
    create_table :t_facesheets do |t|
      t.references :t_workflow, foreign_key: true
      t.boolean :name
      t.boolean :email
      t.boolean :gender
      t.boolean :age
      t.boolean :is_student
      t.boolean :department
      t.boolean :is_opi
      t.boolean :is_teacher
      t.boolean :teach_speaking_experience
      t.boolean :country
      t.boolean :institute

      t.timestamps
    end
  end
end
