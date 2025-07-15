require_dependency Rails.root.join("app", "controllers", "budgets", "investments_controller").to_s

module Budgets
  class InvestmentsController

    private


      def investment_params
        attributes = [:heading_id, :tag_list, :organization_name, :location,
                      :terms_of_service, :skip_map, :related_sdg_list, :related_sua_list,
                      image_attributes: image_attributes,
                      documents_attributes: [:id, :title, :attachment, :cached_attachment, :user_id, :_destroy],
                      map_location_attributes: [:latitude, :longitude, :zoom]]
        params.require(:budget_investment).permit(attributes, translation_params(Budget::Investment))
      end

    end
end
