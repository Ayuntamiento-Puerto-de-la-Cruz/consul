require_dependency Rails.root.join("app", "models", "verification", "management", "document").to_s

class Verification::Management::Document
  def under_age?(response)
    Age.in_years(date_of_birth) < User.minimum_required_age
  end
end
