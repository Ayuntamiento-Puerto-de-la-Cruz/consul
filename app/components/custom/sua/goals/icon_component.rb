class SUA::Goals::IconComponent < ApplicationComponent
  attr_reader :goal, :with_text
  delegate :code, to: :goal

  def initialize(goal, with_text = false)
    @goal = goal
    @with_text = with_text
  end

  def image_path
    "sua/goal_#{code}.png"
  end

  def image_with_text_path
    "sua/with_text/goal_#{code}.png"
  end

  private

    def image_text
      goal.code_and_title
    end

    # def folder
    #   [*I18n.fallbacks[I18n.locale], "default"].find do |locale|
    #     find_asset("sua/#{locale}/goal_#{code}.png")
    #   end
    # end

    # def find_asset(path)
    #   byebug
    #   if Rails.application.assets
    #     Rails.application.assets.find_asset(path)
    #   else
    #     Rails.application.assets_manifest.assets[path]
    #   end
    # end
end
