class AddColumnsToTUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :t_users, :t_experiment, foreign_key: true,　after: :password_digest
    add_reference :t_users, :done_workflow, foreign_key: { to_table: :t_workflows }, after: :password_digest
  end
end
