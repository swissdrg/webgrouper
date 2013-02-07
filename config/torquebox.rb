TorqueBox.configure do
  pool :web, :type => :shared
  
  #Use 1.9 syntax
  ruby do
    version "1.9"
  end
  
  environment do
    RAILS_ENV 'development'
  end

  job Tasks::CleanBatchgroupings do
    cron '0 * * */7 * ?'
    timeout '60s'
    description 'Remove batchgroupings that are older than a year'
  end
end