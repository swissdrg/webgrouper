module ApplicationHelper
  # This helper class choses the appropriate spec file 
  # depending on the chosen in the active system grouper selection
  # and if the sever is a 64 bit machine or not
  # The specs must be in a folder /lib/grouperspecs/ and then in a subfolder 
  # named after their {system_id}:
  def spec_path(system_id)
    if is_64bit?
      spec_file = 'Spec64'
    else
      spec_file = 'Spec'
    end
    # this doesn't work for 32 bits, but right now that's not an issue
    File.join(spec_folder, system_id.to_s, spec_file + "bit.bin")
  end

  #TODO: rewrite this for ruby
  def is_64bit?
    java.lang.System.getProperty('os.arch').include?('64')
  end
  
  def catalogue_path(system_id, house)
    if (house == '1')
      file_name = 'catalogue-acute.csv'
    else
      file_name = 'catalogue-birthhouses.csv'
    end
    File.join(spec_folder, system_id.to_s, file_name)
  end
  
  def spec_folder
    production_spec_folder = File.join('/','home', 'tim', 'grouperspecs')
    development_spec_folder = File.join(Rails.root,'lib', 'grouperspecs')
    if File.directory?(production_spec_folder)
      return production_spec_folder
    else
      return development_spec_folder
    end
  end

  def batchgroupings_temp_folder
    File.join("/tmp", "batchgroupings")
  end

  def shown_systems
    if session[:beta]
      shown_systems = System.all
    else
      shown_systems = System.all_public
    end
    shown_systems.order_by(:id.desc)
  end
end
