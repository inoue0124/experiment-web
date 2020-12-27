class CreateTWorkflows < ActiveRecord::Migration[5.2]
  def change
    create_table :t_workflows do |t|
      t.references :t_experiment, foreign_key: true
      t.references :m_work, foreign_key: true
      t.integer :next_workflow_id

      t.timestamps
    end
  end
end
