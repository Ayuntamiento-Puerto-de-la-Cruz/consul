class SUA::TagComponent < ApplicationComponent
  attr_reader :goal_or_target

  def initialize(goal_or_target)
    @goal_or_target = goal_or_target
  end

  def text
    if goal_or_target.is_a?(SUA::Goal)
      render SUA::Goals::IconComponent.new(goal_or_target, true)
    else
      "#{SUA::Target.model_name.human} #{goal_or_target.code}"
    end
  end
end
