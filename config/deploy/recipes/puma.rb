Capistrano::Configuration.instance(true).load do

  namespace :puma do
    desc "Start Puma"
    task :start, :roles => :app do
      run("sudo /etc/init.d/puma start")
    end

    desc "Stop Puma"
    task :stop, :roles => :app do
      run("sudo /etc/init.d/puma stop")
    end

    desc "Restart Puma"
    task :restart, :roles => :app do
      run("sudo /etc/init.d/puma stop")
      run("sudo /etc/init.d/puma start")
    end

    desc "Phased-Restart Puma"
    task :phased_restart, :roles => :app do
      run("sudo /etc/init.d/puma phased-restart")
    end

    namespace :script do
      desc "uploads script file for puma start/stop"
      task :upload, :roles => :app do
        file_path = File.expand_path('../scripts/puma.erb', File.dirname(__FILE__))
        template = File.read(file_path)
        config = ERB.new( template, 0, '-' )
        run "mkdir -p #{release_path}/script"
        put( config.result( binding ), "#{release_path}/script/puma" )
        run("chmod +x #{release_path}/script/puma")
      end
    end
  end

  after "deploy:update", "puma:script:upload"
  after "deploy:restart", "puma:restart"
end
