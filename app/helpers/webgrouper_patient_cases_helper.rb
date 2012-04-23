module WebgrouperPatientCasesHelper
  
  def spec_path(system_id)
		is_64bit = false	
		if java.lang.System.getProperty('os.arch').include?('64')
			is_64bit = true		
		end
		
    path = case system_id
      when 9
        # path for billing 10 spech
				if is_64bit
					File.join('lib','specs','Spec10billing64bit.bin')
				else File.join('lib','specs','Spec10billing32bit.bin')
				end
      when 8
				if is_64bit
					File.join('lib','specs','Spec10planning2_64bit.bin')
				else 
					File.join('lib','specs','Spec10planning2.bin')
				end
      when 7
				if is_64bit
					File.join('lib','specs','Spec10catalogue64bit.bin')
				else 
					File.join('lib','specs','Spec10catalogue.bin')
				end
      when 6
				if is_64bit
					File.join('lib','specs','Spec03billing64bit.bin')
				else 
					File.join('lib','specs','Spec03billing64bit.bin')
				end
      when 5
				if is_64bit
					File.join('lib','specs','Spec03planning64bit.bin')
				else 
					File.join('lib','specs','Spec03planning.bin')
				end	
      when 4
				# currently we dont have those spec files
      when 2
				# currently we dont have those spec files
      when 1
				# currently we dont have those spec files
    end
		
  end
  
end
