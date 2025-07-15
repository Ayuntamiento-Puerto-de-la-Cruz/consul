module SUA::OptionsForSelect
  extend ActiveSupport::Concern

  def sua_goal_options(selected_code = nil)
    options_from_collection_for_select(SUA::Goal.order(:code), :code, :code_and_title, selected_code)
  end

  def sua_target_options(selected_code = nil)
    targets = SUA::Target.all
    options_from_collection_for_select(targets.sort, :code, :code, selected_code)
  end
end
