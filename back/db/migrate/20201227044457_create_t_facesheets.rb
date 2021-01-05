class CreateTFacesheets < ActiveRecord::Migration[5.2]
  def change
    create_table :t_facesheets do |t|
      t.references :t_workflow, foreign_key: true
      t.boolean :name
      t.boolean :phone

      t.timestamps
    end
  end
end
