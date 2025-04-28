require_dependency Rails.root.join("app", "controllers", "admin", "settings_controller").to_s

class Admin::SettingsController
  def index
    all_settings = Setting.all.group_by(&:type)
    @configuration_settings = all_settings["configuration"]
    @feature_settings = all_settings["feature"]
    @participation_processes_settings = all_settings["process"]
    @map_configuration_settings = all_settings["map"]
    @proposals_settings = all_settings["proposals"]
    @remote_census_general_settings = all_settings["remote_census.general"]
    @remote_census_request_settings = all_settings["remote_census.request"]
    @remote_census_response_settings = all_settings["remote_census.response"]
    @uploads_settings = all_settings["uploads"]
    @sdg_settings = all_settings["sdg"]
    @sua_settings = all_settings["sua"]
  end
end
