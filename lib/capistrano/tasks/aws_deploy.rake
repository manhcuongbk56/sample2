namespace :aws do
  desc "Update latest Rails code to target server"
  task :update_source  do
    puts 'Update source'
    `git pull`
    `cd .. && tar -czf cord_blood_service.tar.gz cord_blood_service`
    DEPLOY_TO_HOSTS.each do |deploy_host|
      `scp -i ~/.ssh/connect-infrastructure.pem ../cord_blood_service.tar.gz ubuntu@#{deploy_host}:~/temp`
    end

    on roles(:app) do
      execute 'cd ~/temp && rm -rf cord_blood_service && tar -xzf cord_blood_service.tar.gz'
      execute "cd ~/temp/cord_blood_service && git remote set-url origin #{DEPLOY_REPO_URL}"
      begin
        execute "cd ~/temp/cord_blood_service && git push -f origin #{DEPLOY_BRANCH}"
      rescue => err
        puts "Error: #{err.message}"
      end

      execute 'cd ~/temp && rm -rf cord_blood_service*'
    end
  end
end