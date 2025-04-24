class CreateSuaGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :sua_goals do |t|
      t.integer :code, null: false
      t.timestamps

      t.index :code, unique: true
    end
  end
end
