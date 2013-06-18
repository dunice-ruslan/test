#load 'deploy'
# Uncomment if you are using Rails' asset pipeline
    # load 'deploy/assets'
#load 'config/deploy' # remove this line to skip loading any of the default tasks
require 'bundler/setup'
Bundler.require(:app_auto_load)

load 'deploy'
Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy' # remove this line to skip loading any of the default tasks
