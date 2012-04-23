config = Rails.configuration.database_configuration
database = config[Rails.env]["database"]
username = config[Rails.env]["username"]
password = config[Rails.env]["password"]

namespace :db do
  
  #rake db:dumpimport - Resets the DB to the entries in the dump.
  desc "imports the dump file into the current db"
  task :dumpimport => :environment do
     if ActiveRecord::Base.connection.table_exists? database
       puts 'dropping old db...'
       Rake::Task['db:drop'].invoke 
     end
     puts 'creating new db...'
     Rake::Task['db:create'].invoke 
     puts "Filling #{database} with data"
     %x[mysql -u #{username} --password=#{password} #{database}<lib/webgrouper-dump_13032012.sql]
  end
end
