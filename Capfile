load 'deploy'
# Uncomment if you are using Rails' asset pipeline
#load 'deploy/assets'
load 'config/deploy' # remove this line to skip loading any of the default tasks

#task :create_db_tables, :hosts => "sifd-hydra.kb.dk" do
#  run "hostname; cd /var/www/sifd/apps/adl/current; pwd; whoami; rake db:migrate"
#end

namespace :rake do
  task :show_tasks do
    run("cd #{deploy_to}/current; echo $PATH; echo $SHELL; rake db:migrate")
  end
end