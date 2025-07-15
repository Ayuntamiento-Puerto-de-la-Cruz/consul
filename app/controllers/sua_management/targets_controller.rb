class SUAManagement::TargetsController < SUAManagement::BaseController
  load_and_authorize_resource class: "SUA::Target"

  def index
    @targets = @targets.sort
  end
end
