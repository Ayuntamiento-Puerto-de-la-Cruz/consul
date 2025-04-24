class SUA::Target < ApplicationRecord
  include SDG::Related

  belongs_to :sua_subgoal, class_name: "SUA::Subgoal"

  validates :code, presence: true, uniqueness: true,
          format: { with: /\A\d+\.\d+\.\d+\z/, message: 'must be X.Y.Z format' }
  validates :sua_subgoal, presence: true

  def title
    I18n.t(
    "sua.goals.goal_#{sua_subgoal.sua_goal.code}" \
    ".subgoals.subgoal_#{sua_subgoal.code_key}" \
    ".targets.target_#{code_key}.title"
    )
  end

  private

  def code_key
    code.tr('.', '_')
  end
end
