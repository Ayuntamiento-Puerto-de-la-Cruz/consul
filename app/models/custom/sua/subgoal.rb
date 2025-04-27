class SUA::Subgoal < ApplicationRecord
  include SDG::Related

  belongs_to :sua_goal,
             class_name: 'SUA::Goal'

  has_many :targets,
           class_name: 'SUA::Target',
           foreign_key: 'sua_subgoal_id',
           dependent: :destroy

  validates :code, presence: true, uniqueness: true,
                   format: { with: /\A\d+\.\d+\z/, message: 'must be X.Y format' }
  validates :sua_goal, presence: true

  def title
    I18n.t("sua.goals.goal_#{sua_goal.code}.subgoals.subgoal_#{code_key}.title")
  end

  def description
    I18n.t("sua.goals.goal_#{sua_goal.code}.subgoals.subgoal_#{code_key}.description")
  end

  def code_key
    code.tr(".", "_")
  end
end
