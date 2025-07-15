class SUAManagement::CardsController < SUAManagement::BaseController
  include Admin::Widget::CardsActions
  helper_method :index_path

  load_and_authorize_resource :phase, class: "SUA::Phase", id_param: "sua_phase_id"
  load_and_authorize_resource :card, through: :phase, class: "Widget::Card"

  private

    def index_path
      sua_management_homepage_path
    end
end
