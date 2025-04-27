class SUA::Goals::TargetsComponent < ApplicationComponent
  attr_reader :goal

  def initialize(goal)
    @goal = goal
  end

  def render?
    feature?("sdg")
  end

  def subgoals
    goal.subgoals.order(:code)
  end

  def targets_for(subgoal)
    subgoal.targets.order(:code)
  end

  private

    def global_targets
      goal.targets
    end

    def title(targets)
      targets.model.model_name.human(count: :other).upcase_first
    end
end
