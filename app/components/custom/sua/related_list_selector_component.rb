class SUA::RelatedListSelectorComponent < ApplicationComponent
  attr_reader :f

  def initialize(form)
    @f = form
  end

  def sua_related_suggestions
    goals_and_targets.map { |goal_or_target| suggestion_tag_for(goal_or_target) }
  end

  def goals_and_targets
    goals.map do |goal|
      global_and_local_targets = goal.targets
      [goal, global_and_local_targets.sort]
    end.flatten
  end

  def suggestion_tag_for(goal_or_target)
    {
      tag: "#{goal_or_target.code}. #{goal_or_target.title.gsub(",", "")}",
      display_text: text_for(goal_or_target),
      title: goal_or_target.title,
      value: goal_or_target.code
    }
  end

  def render?
    SUA::ProcessEnabled.new(f.object).enabled?
  end

  private

    def goals
      SUA::Goal.order(:code)
    end

    def goal_field(checkbox_form)
      goal = checkbox_form.object

      checkbox_form.check_box(data: { code: goal.code }) +
        checkbox_form.label { render(SUA::Goals::IconComponent.new(goal)) }
    end

    def text_for(goal_or_target)
      if goal_or_target.class.name == "SUA::Goal"
        t("sua.related_list_selector.goal_identifier", code: goal_or_target.code)
      else
        goal_or_target.code
      end
    end

    def relatable_name
      f.object.model_name.human.downcase
    end
end
