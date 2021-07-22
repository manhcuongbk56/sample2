
require 'config_service'
require 'active_support/json'
DEPLOY_CONFIG = ConfigService.load_config('deploy/deploy_config.yml')
DEPLOY_ENV =  ENV['cap_env'] || ARGV[0]

DEPLOY_SSH_KEYS     = DEPLOY_CONFIG[DEPLOY_ENV]['ssh_keys']
DEPLOY_APPLICATION  = DEPLOY_CONFIG[DEPLOY_ENV]['application']
DEPLOY_REPO_URL     = DEPLOY_CONFIG[DEPLOY_ENV]['repo_url']
DEPLOY_BRANCH       = (ENV['branch'].to_s.strip != '')? ENV['branch'] : DEPLOY_CONFIG[DEPLOY_ENV]['branch']
DEPLOY_USER         = DEPLOY_CONFIG[DEPLOY_ENV]['deploy_user']
DEPLOY_TO_DIR       = DEPLOY_CONFIG[DEPLOY_ENV]['deploy_to_dir']
DEPLOY_PRODUCTION   = DEPLOY_CONFIG[DEPLOY_ENV]['deploy_production']

deploy_to_hosts = []
if (ENV['targets'].to_s.strip != '')
  # targets is {"app"=>["nobody@localhost"], "db"=>["nobody@localhost"]}.to_json
  begin
    targets = ActiveSupport::JSON.decode(ENV['targets'])
  rescue => exc
    puts "ERROR parsing targets #{ENV['targets'].inspect}: #{exc.message}"
    exit
  end
else
  targets = DEPLOY_CONFIG[DEPLOY_ENV]['roles']
end

targets.to_h.each do |role, user_hosts|
  role role, user_hosts
  user_hosts.each { |info| deploy_to_hosts << info.split('@').last } 
end

DEPLOY_TO_HOSTS = deploy_to_hosts.uniq

# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require "capistrano/deploy"

require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/puma'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }