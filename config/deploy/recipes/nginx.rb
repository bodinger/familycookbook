Capistrano::Configuration.instance(true).load do

  namespace :nginx do
    desc 'Uploads main nginx config for use within cdb-context'
    task :config, :roles => :app do
      file_path = File.expand_path('../configs/nginx.conf.erb', File.dirname(__FILE__))
      template = File.read(file_path)
      erb = ERB.new( template, 0, '-' )
      put( erb.result( binding ), "#{release_path}/config/nginx.conf" )
    end

    desc 'Uploads nginx location/upstream configs if exist for inclusion in main nginx config'
    task :includes, :roles => :app do
      Dir["config/nginx/**/*.erb"].each do |config|
        template = File.read(config)
        erb = ERB.new( template, 0, '-' )
        result_path = config.chomp(".erb")
        put( erb.result( binding ), "#{release_path}/#{result_path}")
      end
    end
  end

  after 'deploy:update', 'nginx:config'
  after 'deploy:update', 'nginx:includes'
end
