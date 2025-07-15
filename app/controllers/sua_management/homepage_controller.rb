class SUAManagement::HomepageController < SUAManagement::BaseController
  def show
    @phases = SUA::Phase.accessible_by(current_ability).order(:kind)
  end
end
