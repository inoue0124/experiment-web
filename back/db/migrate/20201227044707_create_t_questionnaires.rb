class CreateTQuestionnaires < ActiveRecord::Migration[5.2]
  def change
    create_table :t_questionnaires do |t|
      t.references :t_workflow, foreign_key: true
      t.string :url

      t.timestamps
    end
  end
end
