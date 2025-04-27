class CreateSUARelations < ActiveRecord::Migration[5.2]
  def change
    create_table :sua_relations do |t|
      t.references :related_sua, polymorphic: true
      t.references :relatable, polymorphic: true

      t.index [:related_sua_id, :related_sua_type, :relatable_id, :relatable_type], name: "sua_relations_unique", unique: true

      t.timestamps
    end
  end
end
