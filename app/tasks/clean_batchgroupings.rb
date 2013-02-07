require 'fileutils'

module Tasks
  class CleanBatchgroupings

    def run()
      main_folder = File.join("/tmp", "batchgroupings", "*")
      Dir.glob(main_folder).each do |folder|
         if File.ctime(folder) < Date.today # - 7.days
           FileUtils.rm_r folder
         end
      end
      logger.info("Successfully removed old batchgroupings")
    end

    # Optionally implement this method to interrogate any exceptions
    # raised inside the job's run method.
    def on_error(exception)
      logger.warn("Could not make cleanup!")
      logger.warn(exception)
    end

  end
end