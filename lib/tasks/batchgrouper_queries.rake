namespace :batchgrouper_queries do
  desc 'Deletes files of batchgroupings that are older than 14 days. Does this for normal and tarpsy.'
  task :clean => :environment do
    # TODO: Add similar archive function for BatchgroupingQuery
    TarpsyBatchgrouperQuery.where(:create_at.lt => 30.days.ago, archived: false).each do |tbq|
      tbq.archive!
    end
  end
end
