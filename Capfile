load 'deploy'
# Uncomment if you are using Rails' asset pipeline
#load 'deploy/assets'
load 'config/deploy' # remove this line to skip loading any of the default tasks

namespace :rake do
  task :db_migrate do
    run("cd #{deploy_to}/current; rake db:migrate")
  end
end