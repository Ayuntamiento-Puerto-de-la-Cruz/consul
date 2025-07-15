class SUA::Goals::PlainTagListComponent < ApplicationComponent
  include SUA::TagList

  private

    def tags
      [*goal_tags, see_more_link].select(&:present?)
    end

    def goal_tags
      tag_records.map do |goal|
        render SUA::TagComponent.new(goal)
      end
    end

    def association_name
      :sua_goals
    end
end
