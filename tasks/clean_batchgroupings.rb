require 'fileutils'

module Tasks
  class CleanBatchgroupings

    def run()
      folder_search_term = File.join(batchgroupings_temp_folder, "*")
      count = 0;
      Dir.glob(folder_search_term).each do |folder|
         if File.ctime(folder) < Time.now - 14.days
           FileUtils.rm_rf folder
           count += 1
         end
      end
      Rails.logger.info("Successfully removed #{count} old batchgroupings")
    end

    # Optionally implement this method to interrogate any exceptions
    # raised inside the job's run method.
    def on_error(exception)
      Rails.logger.warn("Could not make cleanup!")
      Rails.logger.warn(exception)
    end

  end
end