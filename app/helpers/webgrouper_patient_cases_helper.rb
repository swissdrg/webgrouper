# This helper class choses the appropriate spec file 
# depending on the chosen in the active system grouper selection
# and if the sever is a 64 bit machine or not
# The specs must be in a folder /lib/specs/ and be named as follows:
# {system_id} (Description of Version)

module WebgrouperPatientCasesHelper
  
  def spec_path(system_id)
		if is_64bit?
		  spec_file = 'Spec64.bin'
		else
		  spec_file = 'Spec.bin'
		end

		File.join(Dir.glob("lib/specs/#{system_id} (*"), spec_file)
  end
  
  def is_64bit?
    java.lang.System.getProperty('os.arch').include?('64')
  end
end
