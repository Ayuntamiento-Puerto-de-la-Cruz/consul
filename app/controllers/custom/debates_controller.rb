require_dependency Rails.root.join("app", "controllers", "debates_controller").to_s

class DebatesController
  private

    def debate_params
      attributes = [:tag_list, :terms_of_service, :related_sdg_list, :related_sua_list]
      params.require(:debate).permit(attributes, translation_params(Debate))
    end
end
