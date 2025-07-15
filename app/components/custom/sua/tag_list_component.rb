class SUA::TagListComponent < ApplicationComponent
  attr_reader :record, :limit, :linkable

  def initialize(record, limit: nil, linkable: true)
    @record = record
    @limit = limit
    @linkable = linkable
  end

  private

    def sua_goals_list
      if linkable
        render SUA::Goals::TagListComponent.new(record, limit: limit)
      else
        render SUA::Goals::PlainTagListComponent.new(record, limit: limit)
      end
    end

    def sua_targets_list
      if linkable
        render SUA::Targets::TagListComponent.new(record, limit: limit)
      else
        render SUA::Targets::PlainTagListComponent.new(record, limit: limit)
      end
    end
end
