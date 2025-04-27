class CreateSUASubgoals < ActiveRecord::Migration[5.2]
  def change
    create_table :sua_subgoals do |t|
      t.references :sua_goal

      t.string :code, null: false
      t.timestamps

      t.index :code, unique: true
    end
  end
end
