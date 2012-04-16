config = Rails.configuration.database_configuration
database = config[Rails.env]["database"]
username = config[Rails.env]["username"]
password = config[Rails.env]["password"]

namespace :db do
  
  #rake db:dumpimport - Resets the DB.
  desc "imports the lib/webgrouper_dump.sql file to the current db"
  task :dumpimport => [:environment, :reset] do
     puts "Filling #{database} with data"
     `mysql -u root --password="#{password}" "#{database}" < lib/webgrouper_dump.sql`
  end
end