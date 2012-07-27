TorqueBox.configure do
  pool :web, :type => :shared
  
  web :context => "/webgrouper"
  
  #Use 1.9 syntax
  ruby do
    version "1.9"
  end
  
  environment do
    RAILS_ENV 'production'
  end
end