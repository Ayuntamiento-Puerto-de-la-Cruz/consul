class SUAManagement::BaseController < ApplicationController
  include FeatureFlags
  feature_flag :sua

  layout "admin"

  before_action :authenticate_user!
  before_action :verify_sua_manager

  skip_authorization_check

  private

    def verify_sua_manager
      # raise CanCan::AccessDenied unless current_user&.sua_manager? || current_user&.administrator?
      raise CanCan::AccessDenied unless current_user&.administrator?
    end
end
