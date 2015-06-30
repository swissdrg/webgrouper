namespace :batchgrouper_queries do

  desc 'Deletes files of batchgroupings that are older than 14 days. Does this for normal and tarpsy.'
  task :clean => :environment do
    archive_deadline = if Rails.env == 'development'
                         Time.now
                       else
                         30.days.ago
                       end
    TarpsyBatchgrouperQuery.where(:created_at.lt => archive_deadline, archived: false).each do |tbq|
      tbq.archive!
    end

    BatchgrouperQuery.where(:created_at.lt => archive_deadline, archived: false).each do |bq|
      bq.archive!
    end

  end
end
