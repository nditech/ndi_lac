require "bundler/capistrano"

set :application, "ndi_lac"
set :repository,  "git@github.com:parbros/ndi_lac.git"
set :deploy_to, "/home/red-innovadores/apps/#{application}"

_cset(:app_env)        { (fetch(:rails_env) rescue 'production') }



# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :use_sudo, false
set :scm, :git
set :deploy_via, :remote_cache
set :branch, "master"
role :web, "198.211.104.120"                          # Your HTTP server, Apache/etc
role :app, "198.211.104.120"
role :db, "198.211.104.120", primary: true
set :user, "red-innovadores"
set :keep_releases, 5

set :normalize_asset_timestamps, false
set :bundle_cmd, "/home/red-innovadores/.rbenv/shims/bundle"


namespace :db do
  task :db_config, :except => { :no_release => true }, :role => :app do
    run "cp -f #{deploy_to}/shared/database.yml #{release_path}/config/database.yml"
  end
end

namespace :deploy do
  task :precompile, :role => :app do
    run "cd #{release_path}/ && RAILS_ENV=#{rails_env} #{bundle_cmd} exec rake assets:precompile"
  end
end

namespace :puma do
  task :start, :role => :app do
    run "cd #{release_path}/ && #{bundle_cmd} exec puma -C config/puma.rb"
  end
  
  task :stop. :role => :app do
    run "cd #{release_path}/ && #{bundle_cmd} exec puma -C config/puma.rb stop"
  end
  
  task :restart. :role => :app do
    run "cd #{release_path}/ && #{bundle_cmd} exec puma -C config/puma.rb restart"
  end
end


after "deploy:finalize_update", "db:db_config"
after "deploy:finalize_update", "deploy:precompile"

after "deploy:start",          "puma:start"
after "deploy:stop",           "puma:stop"
after "deploy:restart",        "puma:restart"