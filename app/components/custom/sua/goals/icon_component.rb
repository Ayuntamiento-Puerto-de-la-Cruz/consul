class SUA::Goals::IconComponent < ApplicationComponent
  attr_reader :goal, :with_text
  delegate :code, to: :goal

  def initialize(goal, with_text = false)
    @goal = goal
    @with_text = with_text
  end

  def image_path
    "sua/goal_#{code}.png"
  end

  def image_with_text_path
    "sua/with_text/goal_#{code}.png"
  end

  private

    def image_text
      goal.code_and_title
    end
end
