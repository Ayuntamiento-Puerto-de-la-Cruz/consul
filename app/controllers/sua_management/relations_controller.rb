class SUAManagement::RelationsController < SUAManagement::BaseController
  before_action :check_feature_flags
  before_action :load_record, only: [:edit, :update]

  FILTERS = %w[pending_sua_review all sua_reviewed].freeze
  has_filters FILTERS, only: :index

  def index
    @records = relatable_class
               .send(@current_filter)
               .accessible_by(current_ability)
               .by_sua_goal(params[:goal_code])
               .by_sua_target(params[:target_code])
               .order(:id)
               .page(params[:page])

    @records = @records.search(params[:search]) if params[:search].present?
  end

  def edit
  end

  def update
    @record.related_sua_list = params[@record.class.table_name.singularize][:related_sua_list]

    redirect_to({ action: :index }, notice: update_notice)
  end

  private

    def load_record
      @record = relatable_class.find(params[:id])
    end

    def relatable_class
      params[:relatable_type].classify.constantize
    end

    def check_feature_flags
      process_name = params[:relatable_type].split("/").first
      process_name = process_name.pluralize unless process_name == "legislation"

      check_feature_flag(process_name)
      raise FeatureDisabled, process_name unless Setting["sua.process.#{process_name}"]
    end

    def update_notice
      if @record.sua_review.present?
        t("sua_management.relations.update.notice", relatable: relatable_class.model_name.human)
      else
        @record.create_sua_review!
        t("sua_management.relations.update_and_review.notice", relatable: relatable_class.model_name.human)
      end
    end
end
