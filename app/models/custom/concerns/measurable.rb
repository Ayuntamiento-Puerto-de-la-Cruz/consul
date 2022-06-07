module Measurable
  extend ActiveSupport::Concern

  class_methods do
    def description_max_length
      12000
    end
  end
end
