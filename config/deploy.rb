# По умолчанию для дистрибуции проектов используется Bundler.
# Эта строка включает автоматическое обновление и установку
# недостающих gems, указанных в вашем Gemfile.
#
## !!! Не забудьте добавить
# gem 'capistrano'
# gem 'unicorn'
#
# в ваш Gemfile.
#
# Если вы используете другую систему управления зависимостями,
# закомментируйте эту строку.
require 'bundler/capistrano'

load 'deploy/assets'

# Для удобства работы мы рекомендуем вам настроить авторизацию
# SSH по ключу. При работе capistrano будет использоваться
# ssh-agent, который предоставляет возможность пробрасывать
# авторизацию на другие хосты.
# Если вы не используете авторизацию SSH по ключам И ssh-agent,
# закомментируйте эту опцию.
#ssh_options[:forward_agent] = true

# Имя вашего проекта в панели управления.
# Не меняйте это значение без необходимости, оно используется дальше.
set :application,     "test"

# Сервер размещения проекта.
set :deploy_server,   "vs02.secoint.ru"

# Не включать в поставку разработческие инструменты и пакеты тестирования.
#set :bundle_without,  [:development, :test]

set :user,            "instamart"
set :login,           "instamart"
set :use_sudo,        false
set :deploy_to,       "/home/#{user}/#{application}"
set :unicorn_conf,    "/etc/unicorn/#{application}.#{login}.rb"
set :unicorn_pid,     "/var/run/unicorn/#{application}.#{login}.pid"
set :bundle_dir,      File.join(fetch(:shared_path), 'gems')
role :web,            deploy_server
role :app,            deploy_server
role :db,             deploy_server, :primary => true

# Следующие строки необходимы, т.к. ваш проект использует rvm.
set :rvm_ruby_string, "1.9.3"
set :rake,            "rvm use #{rvm_ruby_string} do bundle exec rake"
set :bundle_cmd,      "rvm use #{rvm_ruby_string} do bundle"

set :scm,             :git
set :repository,      "git@github.com:dunice-ruslan/test.git"

before 'deploy:finalize_update', 'set_current_release'
task :set_current_release, :roles => :app do
  set :current_release, latest_release
end



