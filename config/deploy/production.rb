set :application, "vpb"
set :branch,  source_branch('development')
set :deploy_to, "/var/www/#{application}/production"
set :rails_env,:production
set :user, 'deploy'
# set :password
# Add public keys to the deploy users authorized list.
server 'kaltura-webapp.concord.org', :app, :web, :db, :primary=>true
