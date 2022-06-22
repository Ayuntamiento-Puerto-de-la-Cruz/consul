set :branch, ENV["branch"] || :staging

server deploysecret(:server), user: deploysecret(:user), roles: %w[web app db importer cron background]
set :rails_env, :staging
