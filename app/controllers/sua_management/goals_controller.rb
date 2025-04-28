class SUAManagement::GoalsController < SUAManagement::BaseController
  load_and_authorize_resource class: "SUA::Goal"

  def index
    @goals = @goals.order(:code)
  end
end
