require 'fileutils'

module Tasks
  class CleanBatchgroupings

    def run()
      main_folder = batchgroupings_temp_folder
      Dir.glob(main_folder).each do |folder|
         if File.ctime(folder) < Time.now - 14.days
           FileUtils.rm_r folder
         end
      end
      Rails.logger.info("Successfully removed old batchgroupings")
    end

    # Optionally implement this method to interrogate any exceptions
    # raised inside the job's run method.
    def on_error(exception)
      Rails.logger.warn("Could not make cleanup!")
      Rails.logger.warn(exception)
    end

  end
end