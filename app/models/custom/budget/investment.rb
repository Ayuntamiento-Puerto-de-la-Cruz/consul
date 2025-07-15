require_dependency Rails.root.join("app", "models", "budget", "investment").to_s

class Budget
  class Investment
    include SUA::Relatable
  end
end
