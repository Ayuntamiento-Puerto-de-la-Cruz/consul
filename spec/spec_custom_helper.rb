require "simplecov"
SimpleCov.start

RSpec.configure do |config|
  config.before(:each, :remote_census) do |example|
    Setting["remote_census.response.valid"] = "existe_padron_response.existe_padron_result"
  end
end
