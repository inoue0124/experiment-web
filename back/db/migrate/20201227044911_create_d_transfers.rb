class CreateDTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :d_transfers do |t|
      t.references :t_user, foreign_key: true
      t.string :excel_url

      t.timestamps
    end
  end
end
