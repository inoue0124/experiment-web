class CreateTAgreements < ActiveRecord::Migration[5.2]
  def change
    create_table :t_agreements do |t|
      t.references :t_workflow, foreign_key: true
      t.text :text

      t.timestamps
    end
  end
end
