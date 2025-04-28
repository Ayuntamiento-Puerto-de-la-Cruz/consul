class SUA::Targets::TagListComponent < ApplicationComponent
  include SUA::TagList

  private

    def association_name
      :sua_targets
    end

    def related_model
      record.class
    end
end
