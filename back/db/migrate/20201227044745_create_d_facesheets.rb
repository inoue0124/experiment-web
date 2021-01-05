class CreateDFacesheets < ActiveRecord::Migration[5.2]
  def change
    create_table :d_facesheets do |t|
      t.references :t_user, foreign_key: true
      t.references :t_facesheet, foreign_key: true
      t.string :name
      t.string :phone

      t.timestamps
    end
  end
end
