class CreateTExperiments < ActiveRecord::Migration[5.2]
  def change
    create_table :t_experiments do |t|
      t.string :name

      t.timestamps
    end
  end
end
