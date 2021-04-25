class CreateTTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :t_transfers do |t|
      t.references :t_workflow, foreign_key: true
      t.boolean :is_second_time

      t.timestamps
    end
  end
end
