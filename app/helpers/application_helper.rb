module ApplicationHelper
  # This helper class choses the appropriate spec file 
  # depending on the chosen in the active system grouper selection
  # and if the sever is a 64 bit machine or not
  # The specs must be in a folder /lib/specs/ and be named as follows:
  # {system_id} (Description of Version)
  def spec_path(system_id)
    if is_64bit?
      spec_file = 'Spec64'
    else
      spec_file = 'Spec'
    end
    
    if (Rails.env == "production" && File.directory?(production_spec_folder))
      # this doesn't work for 32 bits, but right now that's not an issue
      File.join(production_spec_folder, system_id.to_s, spec_file + "bit.bin")
    else
      File.join(Dir.glob(Rails.root + "lib/grouper_specs/#{system_id} (*"), spec_file + ".bin")
    end
  end
  
  def is_64bit?
    java.lang.System.getProperty('os.arch').include?('64')
  end
  
  #TODO: fix
  def catalogue_path(system_id, house)
    if (house == 1)
      file_name = 'catalogue-acute.csv'
    else
      file_name = 'catalogue-birthhouses.csv'
    end
    
    if (Rails.env == "production" && File.directory?(production_spec_folder))
      File.join(production_spec_folder, system_id.to_s, file_name)
    end
  end
  
  def production_spec_folder
    File.join('/','home', 'tim', 'grouperspecs')
  end
end
