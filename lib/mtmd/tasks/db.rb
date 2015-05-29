require 'logger'

def message(message, separator = "\n----------------------------------------------------\n")
  puts "#{separator}#{Padrino.env.upcase}: #{message}#{separator}"
end

def absolute_path(*relative_parts)
  gem_root = File.expand_path('../', File.dirname(__FILE__))
  File.join(gem_root, *relative_parts)
end

def migrations_dir
  'db/migrations'
end

def env_db_instance
  return unless Padrino.respond_to?(:env)
  env_db_config = MTMD::Core::Config.new(Padrino.env).db_config

  return if env_db_config.nil?

  MTMD::Db.new(env_db_config, Logger.new($stdout))
end

# Create a valid db instance.
db = env_db_instance

desc "Environment task checks for valid database instance in environment"
task :environment do
  next if db.nil?
end


namespace :mtmd do
  desc "Perform database migration up to latest migration available or a provided version"
  task :migrate, [:version] => :environment do |t, args|
    next if db.nil?
    version = args[:version]
     if version.blank?
       message "Migrating database to most recent version"
       Sequel::IntegerMigrator.new(db.get_instance, migrations_dir).run
     else
       message "Migrating database to selected version #{version}"
       Sequel::IntegerMigrator.new(db.get_instance, migrations_dir, :target => version.to_i).run
    end
    Rake::Task['mtmd:dbversion'].invoke
  end

  desc "Show current database version"
  task :dbversion => :environment do
    next if db.nil?
    migrator = Sequel::IntegerMigrator.new(db.get_instance, migrations_dir)
    message "Database is at migration version #{migrator.current}"
  end

  desc "Perform a database rollback down to empty schema (if you dont provide a version ALL DATA WILL BE DELETED)"
  task :rollback, [:version] => :environment do |t, args|
    next if db.nil?
    version = args[:version]
    if version.blank?
      version = 0
    end
    message "Performing a database rollback down to schema version #{version}."
    Rake::Task['mtmd:migrate'].invoke(version)
  end

  desc "Perform a migration reset (full rollback and migration - ALL DATA WILL BE DELETED)"
  task :reset => :environment do
    next if db.nil?
    message "Resetting database"
    Sequel::IntegerMigrator.new(db.get_instance, migrations_dir, :target => 0).run
    Sequel::IntegerMigrator.new(db.get_instance, migrations_dir).run
    Rake::Task['mtmd:dbversion'].invoke
  end

  desc "Load seed data from file to database"
  task :seed => :environment do
    next if db.nil?
    message "Loading seed data"
    seed_file = File.join('db', 'seeds.rb')
    load(seed_file) if File.exist?(seed_file)
  end

  #
  # namespace 'schema' do
  #   desc 'Generate Schema File'
  #   task :dump do
  #     loggers = dbinstance.loggers
  #     dbinstance.loggers = []
  #
  #     schema_file = File.join(absolute_path("lib/mtmd/db"), 'schema.rb')
  #     File.open(schema_file, "w") do |file|
  #       file.write(dbinstance.dump_schema_migration)
  #     end
  #
  #     dbinstance.loggers = loggers
  #   end
  # end
end
