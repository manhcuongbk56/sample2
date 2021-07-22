namespace :puma do
  desc "Safely restart puma"
  task :safe_restart  do
    puts 'Safely restart puma'
    file_exist = nil
    socket_file = "#{DEPLOY_TO_DIR}/shared/tmp/sockets/pumactl.sock"
    on roles(:app) do
      file_exist = (capture("ruby -e 'puts(File.exists?(\"#{socket_file}\"))'") == 'true')
    end

    puma_command = (file_exist)? 'restart' : 'start'
    puts "#{puma_command.capitalize}ing Puma ..."
    `cap #{DEPLOY_ENV} puma:#{puma_command}` 
  end
end