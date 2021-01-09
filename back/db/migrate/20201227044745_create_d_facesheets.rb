class CreateDFacesheets < ActiveRecord::Migration[5.2]
  def change
    create_table :d_facesheets do |t|
      t.references :t_user, foreign_key: true
      t.references :t_facesheet, foreign_key: true
      t.string :name
      t.string :email
      t.integer :gender
      t.integer :age
      t.integer :is_student
      t.integer :department_type
      t.string :department_name
      t.integer :is_opi
      t.integer :is_teacher
      t.integer :teaching_years
      t.integer :teach_speaking_experience
      t.integer :teach_speaking_years
      t.integer :is_japan
      t.string :country_name
      t.integer :institute
      t.string :other_institute

      t.timestamps
    end
  end
end
