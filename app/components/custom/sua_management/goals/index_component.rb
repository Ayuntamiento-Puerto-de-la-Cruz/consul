class SUAManagement::Goals::IndexComponent < ApplicationComponent
  include Header

  attr_reader :goals

  def initialize(goals)
    @goals = goals
  end

  private

    def title
      SUA::Goal.model_name.human(count: 2).titleize
    end

    def attribute_name(attribute)
      SUA::Goal.human_attribute_name(attribute)
    end
end
