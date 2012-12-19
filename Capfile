load 'deploy'
# Uncomment if you are using Rails' asset pipeline
#load 'deploy/assets'
load 'config/deploy' # remove this line to skip loading any of the default tasks

task :create_db_tables, :hosts => "sifd-hydra.kb.dk" do
  run "cd /var/www/sifd/apps/adl/current; rake db:migrate"
end