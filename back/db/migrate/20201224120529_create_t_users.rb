class CreateTUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :t_users do |t|
      t.string :uuid
      t.string :email
      t.string :password_digest
      t.integer :user_type
      t.integer :t_experiment_id
      t.integer :done_workflow_id

      t.timestamps
    end
  end
end
