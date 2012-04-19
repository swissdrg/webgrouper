config = Rails.configuration.database_configuration
database = config[Rails.env]["database"]
username = config[Rails.env]["username"]
password = config[Rails.env]["password"]

namespace :db do
  
  #rake db:dumpimport - Resets the DB to the entries in the dump.
  desc "imports the dump file into the current db"
  task :dumpimport => :environment do
     puts 'dropping and re-creating db...'
     #Rake::Task['db:drop'].invoke unless does not exist
     Rake::Task['db:create'].invoke
     puts "Filling #{database} with data"
     sh "mysql -u #{username} --password=#{password} #{database}<lib/webgrouper-dump_13032012.sql"
  end
end