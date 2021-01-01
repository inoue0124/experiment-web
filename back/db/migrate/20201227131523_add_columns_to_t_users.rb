class AddColumnsToTUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :t_users, :t_experiment, after: :password_digest
    add_reference :t_users, :done_workflow, after: :password_digest
  end
end
