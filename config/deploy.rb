# For deploy use parameter -S domain=user@host:port, for example
# cap deploy -S domain=deployer@youdomain.com:22

set :application, "hhstat"
set :repository,  "https://github.com/holyketzer/hhstat.git"
set :deploy_to, "/var/www/hhstat"

set :domain, fetch(:domain, '')

puts "Wash! Rinse! Repeat!"

# adjust if you are using RVM, remove if you are not
set :rvm_type, :user
set :rvm_ruby_string, 'ruby-2.0.0-p247'
require 'rvm/capistrano'

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# distribute your applications across servers (the instructions below put them
# all on the same server, defined above as 'domain', adjust as necessary)
role :app, domain
role :web, domain
role :db, domain, :primary => true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

# miscellaneous options
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false
set :normalize_asset_timestamps, false
set :rails_env, :production

namespace :deploy do
  desc "Cause Passenger to initiate a restart"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "reload the database with seed data"
  task :seed do
    deploy.migrations
    run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
  end
end