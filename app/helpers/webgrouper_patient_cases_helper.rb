# This helper class choses the appropriate spec file 
# depending on the chosen in the active system grouper selection
# and if the sever is a 64 bit machine or not

module WebgrouperPatientCasesHelper
  
  def spec_path(system_id)
		is_64bit = false	
		if java.lang.System.getProperty('os.arch').include?('64')
			is_64bit = true		
		end

    spec_file = case system_id
    when 9
			is_64bit ? 'Spec10billing64bit.bin' : 'Spec10billing32bit.bin'
    when 8
			is_64bit ? 'Spec10planning2_64bit.bin' : 'Spec10planning2.bin'
    when 7
			is_64bit ? 'Spec10catalogue64bit.bin' : 'Spec10catalogue.bin'
    when 6
			is_64bit ? 'Spec03billing64bit.bin' : 'Spec03billing64bit.bin'
    when 5
			is_64bit ? 'Spec03planning64bit.bin' : 'Spec03planning.bin'
    when 4
			# currently we dont have those spec files
    when 2
			# currently we dont have those spec files
    when 1
			# currently we dont have those spec files
    end

		File.join('lib','specs',spec_file)
  end
  
end
