require_dependency Rails.root.join("app", "models", "debate").to_s

require "numeric"
class Debate
  include SUA::Relatable
end
