TorqueBox.configure do

  #Use 1.9 syntax
  ruby do
    version "1.9"
  end
  
  environment do
    RAILS_ENV 'production'
  end

  job Tasks::CleanBatchgroupings do
    cron '0 0 0 */1 * ?'
    # not supported yet
    timeout '60s'
    description 'Remove batchgroupings that are older than a week'
  end

  # only one instance at a time to prevent nasty segfaults
  pool :web do
    type :bounded
    min 4
    max 4
  end

end