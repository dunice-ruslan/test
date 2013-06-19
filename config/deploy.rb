# require './config/boot'
require 'bundler/capistrano'
#require 'airbrake/capistrano'

set :application, 'test'
set :scm, :git
set :repository, 'git@github.com:dunice-ruslan/test.git'
set :deploy_to, '/home/instamart/test'
set :user, 'instamart'
set :use_sudo, false
set :unicorn_rails, 'bundle exec unicorn'
set :unicorn_conf, "#{shared_path}/config/unicorn.rb"
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :rvm_type, :user 
set :default_shell, :bash

require 'rvm/capistrano'

role :web, 'vs02.secoint.ru'
role :app, 'vs02.secoint.ru'
role :db, 'vs02.secoint.ru', :primary => true

namespace(:customs) do
  task :config, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/spree #{release_path}/public"
    run "ln -nfs #{shared_path}/ckeditor_assets #{release_path}/public"
  end
end

namespace :deploy do
  desc 'Start application'
  task :start, :roles => :app do
    run "cd #{current_path} && MAGICK_THREAD_LIMIT=1 #{unicorn_rails} -Dc #{unicorn_conf} -E production"
  end

  desc 'Stop application'
  task :stop, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
  end

  desc 'Restart Application'
  task :restart, :roles => :app do
    stop
    start
  end

  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      run %Q{cd #{latest_release} && #{rake} RAILS_ENV=production assets:clean && #{rake} RAILS_ENV=production assets:precompile}
    end
  end

end

after "deploy", "refresh_sitemaps"
task :refresh_sitemaps do
  run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake sitemap:refresh"
end

after 'deploy:update_code', 'deploy:assets:precompile'
before 'deploy:setup', 'rvm:install_rvm', 'rvm:install_ruby'
after 'deploy:finalize_update', 'customs:config'
after 'deploy:create_symlink', 'customs:symlink'
after 'deploy', 'deploy:cleanup'
after 'deploy', 'deploy:migrate'
