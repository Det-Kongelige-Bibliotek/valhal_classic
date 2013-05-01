server 'sifd-hydra.kb.dk', :web, :app, primary: true
set :deploy_to, "/var/www/sifd/apps/adl"
set :user, "deploy"
set :use_sudo, false
set :rails_env, "development"
set :default_shell, "bash -l"