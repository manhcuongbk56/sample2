# config valid only for current version of Capistrano
lock '3.5.0'

puts "\n\e[0;31m   #########################################################################"
puts "   \n   This is going to deploy '#{DEPLOY_APPLICATION}' environment '#{DEPLOY_ENV}' on\n    #{DEPLOY_TO_HOSTS.join("\n    ")}"
puts "   #########################################################################\e[0m\n"

set :application, DEPLOY_APPLICATION
set :repo_url, DEPLOY_REPO_URL

DEPLOY_BRANCH = ENV['branch'] || DEPLOY_BRANCH
set :branch, DEPLOY_BRANCH
puts "Deploy using code in branch #{DEPLOY_BRANCH}"

# Default deploy_to directory is /var/www/cord_blood_service
set :deploy_to, DEPLOY_TO_DIR

set :rvm_type, :auto
set :rvm_ruby_version, '2.3.0'

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/authentication.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
before :deploy, 'aws:update_source' if ['staging', 'production'].include?(DEPLOY_ENV)
after :deploy, 'puma:safe_restart'

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
