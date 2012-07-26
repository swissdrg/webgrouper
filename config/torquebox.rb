TorqueBox.configure do
  pool :web, :type => :shared
  
  #Use 1.9 syntax
  ruby do
    version "1.9"
  end
  
  job RemoveOldQueries do
    cron '0 0/5 * * * ?'
  end
end