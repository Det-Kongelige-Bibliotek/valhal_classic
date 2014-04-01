load 'deploy'
# Uncomment if you are using Rails' asset pipeline
#load 'deploy/assets'
load 'config/deploy' # remove this line to skip loading any of the default tasks

namespace :rake do #this task ensures that rake db:migrate is executed on the development server after deployment
  task :jetty_stop do
    run("cd #{deploy_to}/current; bundle exec rake jetty:stop")
  end
  task :jetty_config do
    run ("cd #{deploy_to}/current; bundle exec rake jetty:config")
  end
  task :jetty_start do
    run("cd #{deploy_to}/current; bundle exec rake jetty:start")
  end
  task :db_migrate do
    run("cd #{deploy_to}/current; bundle exec rake db:migrate")
  end
end