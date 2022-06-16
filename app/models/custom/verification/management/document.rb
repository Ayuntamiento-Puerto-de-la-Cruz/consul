require_dependency Rails.root.join("app", "models", "verification", "management", "document").to_s

class Verification::Management::Document
  def under_age?(response)
    # There is no data in the response from the census, so we use the age that the user input
    Age.in_years(date_of_birth) < User.minimum_required_age
  end
end
