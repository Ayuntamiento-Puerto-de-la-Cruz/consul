class SUAManagement::Relations::SearchComponent < ApplicationComponent
  include SUA::OptionsForSelect
  attr_reader :label, :current_filter

  def initialize(label:, current_filter: nil)
    @label = label
    @current_filter = current_filter
  end

  private

    def goal_label
      t("admin.shared.search.advanced_filters.sua_goals.label")
    end

    def goal_blank_option
      t("admin.shared.search.advanced_filters.sua_goals.all")
    end

    def target_label
      t("admin.shared.search.advanced_filters.sua_targets.label")
    end

    def target_blank_option
      t("admin.shared.search.advanced_filters.sua_targets.all")
    end

    def sua_goal_options
      super(params[:goal_code])
    end

    def sua_target_options
      super(params[:target_code])
    end
end
