Capistrano::Configuration.instance(true).load do
  namespace :config do
    desc "Creates and uploads the various configuration files"
    task :upload do
      conf_templates.each do |conf_file|
        template = File.read( "#{conf_file}.erb" )
        config = ERB.new( template, 0, '-' )
        put( config.result( binding ), "#{release_path}/#{conf_file}" )

        if conf_file.start_with?('script')
          run("chmod +x #{release_path}/#{conf_file}")
        end
      end
    end
  end

  after "deploy:update", "config:upload"
end
