module Consul
  class Application < Rails::Application
    config.i18n.default_locale = :es
    config.i18n.available_locales = [:es]
    config.paths["app/helpers"].unshift(Rails.root.join("app", "helpers", "custom"))
  end
end
