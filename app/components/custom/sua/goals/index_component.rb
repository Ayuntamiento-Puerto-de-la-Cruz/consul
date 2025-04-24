class SUA::Goals::IndexComponent < ApplicationComponent
  attr_reader :goals
  delegate :link_list, to: :helpers

  def initialize(goals)
    @goals = goals
  end

  private

    def title
      t("sdg.goals.title")
    end

    def goal_links
      goals.map { |goal| goal_link(goal) }
    end

    def goal_link(goal)
      [icon(goal), sua_goal_path(goal.code)]
    end

    def icon(goal)
      render SUA::Goals::IconComponent.new(goal)
    end
end
