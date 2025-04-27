class SUA::GoalsController < ApplicationController
  include FeatureFlags
  feature_flag :sua
  load_and_authorize_resource class: "SUA::Goal", find_by: :code, id_param: :code

  def index
    @goals = @goals.order(:code)
    # @phases = SDG::Phase.accessible_by(current_ability).order(:kind)
  end

  def show
  end
end
