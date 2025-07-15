class SUAManagement::MenuComponent < ApplicationComponent
  include LinkListHelper

  private

    def links
      [goals_link, homepage_link, *relatable_links]
    end

    def goals_link
      [item_text("sua_content"), sua_management_goals_path, sua?, class: "goals-link"]
    end

    def homepage_link
      [item_text("sua_homepage"), sua_management_homepage_path, homepage?, class: "homepage-link"]
    end

    def relatable_links
      SUA::Related::RELATABLE_TYPES.map do |type|
        next unless SUA::ProcessEnabled.new(type).enabled?

        [
          item_text(table_name(type)),
          relatable_type_path(type),
          controller_name == "relations" && params[:relatable_type] == type.tableize,
          class: "#{table_name(type).tr("_", "-")}-link"
        ]
      end
    end

    def sua?
      %w[goals targets].include?(controller_name)
    end

    def homepage?
      controller_name == "homepage"
    end

    def relatable_type_path(type)
      {
        controller: "sua_management/relations",
        action: :index,
        relatable_type: type.tableize
      }
    end

    def table_name(type)
      type.constantize.table_name
    end

    def item_text(item)
      t("sua_management.menu.#{item}")
    end
end
