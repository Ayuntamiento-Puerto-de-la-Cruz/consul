class SUA::Relation < ApplicationRecord
  validates :related_sua_id, uniqueness: { scope: [:related_sua_type, :relatable_id, :relatable_type] }

  belongs_to :relatable, polymorphic: true, optional: false, touch: true
  belongs_to :related_sua, polymorphic: true, optional: false
end
