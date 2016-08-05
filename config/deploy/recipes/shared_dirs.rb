Capistrano::Configuration.instance(true).load do
  namespace :shared do
    desc "Creates missing shared dirs"
    task :dirs, :roles => :app do
      fetch(:shared_dirs).each do |dir|
        run "mkdir -p #{shared_path}/#{dir}"
      end
    end

    desc "Sets correct permissions on shared folders"
    task :permissions, :roles => :app do
     ["pids", "sockets", "log"].each do |dir|
       run "chmod 770 #{shared_path}/#{dir}"
     end
    end
   end

  after "deploy:setup", "shared:dirs"
  after "deploy:setup", "shared:permissions"
end
