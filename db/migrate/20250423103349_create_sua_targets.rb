class CreateSUATargets < ActiveRecord::Migration[5.2]
  def change
    create_table :sua_targets do |t|
      t.references :sua_subgoal

      t.string :code, null: false
      t.timestamps

      t.index :code, unique: true
    end
  end
end
