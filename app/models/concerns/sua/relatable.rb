module SUA::Relatable
  extend ActiveSupport::Concern

  included do
    has_many :sua_relations, as: :relatable, dependent: :destroy, class_name: "SUA::Relation"


    has_many "SUA::Goal".constantize.table_name.to_sym,
              through: :sua_relations,
              source: :related_sua,
              source_type: "SUA::Goal"

    has_many :sua_global_targets,
             through: :sua_relations,
             source: :related_sua,
             source_type: "SUA::Target"

    has_one :sua_review, as: :relatable, dependent: :destroy, class_name: "SUA::Review"
  end

  class_methods do
    def by_goal(code)
      by_sua_related(:sua_goals, code)
    end

    def by_target(code)
      if SUA::Target.find_by(code: code)
        by_sua_related(:sua_global_targets, code)
      end
    end

    def by_sua_related(association, code)
      return all if code.blank?

      sua_class = reflect_on_association(association).options[:source_type].constantize

      joins(association).merge(sua_class.where(code: code))
    end

    def sua_reviewed
      joins(:sua_review)
    end

    def pending_sua_review
      left_joins(:sua_review).merge(SUA::Review.where(id: nil))
    end
  end

  def related_suas
    sua_relations.map(&:related_sua)
  end

  def sua_targets
    sua_global_targets
  end

  def sua_targets=(targets)
    global_targets, local_targets = targets.partition { |target| target.class.name == "SUA::Target" }

    transaction do
      self.sua_global_targets = global_targets
    end
  end

  def sua_goal_list
    sua_goals.order(:code).map(&:code).join(", ")
  end

  def sua_target_list
    sua_targets.sort.map(&:code).join(", ")
  end

  def related_sua_list
    related_suas.sort.map(&:code).join(", ")
  end

  def related_sua_list=(codes)
    target_codes, goal_codes = codes.tr(" ", "").split(",").partition { |code| code.include?(".") }
    local_targets_codes, global_targets_codes = target_codes.partition { |code| code.split(".")[2] }
    global_targets = global_targets_codes.map { |code| SUA::Target[code] }
    goals = goal_codes.map { |code| SUA::Goal[code] }

    transaction do
      self.sua_global_targets = global_targets
      self.sua_goals = (global_targets.map(&:goal) + goals).uniq
    end
  end
end
