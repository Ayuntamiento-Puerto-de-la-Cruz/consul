class SUA::Goal < ApplicationRecord
  include SDG::Related

  validates :code, presence: true, uniqueness: true, inclusion: { in: 1..17 }

  has_many :subgoals,
           class_name: 'SUA::Subgoal',
           foreign_key: 'sua_goal_id',
           dependent: :destroy

  has_many :targets,
           through: :subgoals,
           source: :targets

  def title
    I18n.t("sua.goals.goal_#{code}.title")
  end

  def title_in_two_lines
    I18n.t("sua.goals.goal_#{code}.title_in_two_lines")
  end

  def description
    I18n.t("sua.goals.goal_#{code}.description")
  end

  def self.[](code)
    find_by!(code: code)
  end

  def code_and_title
    "#{code}. #{title}"
  end
end
