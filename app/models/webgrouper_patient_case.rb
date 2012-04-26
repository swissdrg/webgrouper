# WebgrouperPatientCase holds all input variables for a certain patiant case
# you can find in either the entry date, the exit date and the number of leave days. 
# WebgrouperPatientCase inherits from the java class PatientCase
class WebgrouperPatientCase < PatientCase
  
  include ActAsValidGrouperQuery
  
  attr_accessor :age, :age_mode, :care_provider, :manual_submission
  
  # invokes superconstructor of java class PatientCase
	# prepares values of attribute hash for the ruby patient class.
  def initialize(attributes = {})
    super()  
    # initialize attributes to display correct default values in view
    self.age = 40
    self.los = 10
    self.birth_date = ""
    self.entry_date = ""
    self.exit_date = ""
    self.adm_weight = 4000
	  self.adm = "99" #aka unknown
    self.sep = "99" #aka unknown
    self.pdx = ""
    
    attributes.each do |name, value|
      if send(name).is_a? Fixnum
        value = value.to_i 
      end

      send("#{name}=", value) 
    end
    
    if age_mode_days?
      self.age_days = self.age
    else
      self.age_years = self.age
    end
   
  end
  
  # Always returns false since our model is not persisted (saved in a database).
  # The method is necessary for this model to be treated like an active record model
  # in certain circumstances; when building forms for it, for instance.
  def persisted?
    false
  end

  def diagnoses=(diagnoses)
	  set_diagnoses hash_to_java_array(diagnoses, 99, true)
  end
  
  def diagnoses
    diagnoses = []
    get_diagnoses.each do |d|
      diagnoses << d unless d.nil?
    end
    diagnoses
  end

  def procedures=(procedures)
		set_procedures hash_to_java_array(procedures, 100, false)
  end
  
  def procedures
    procedures = []
    get_procedures.each do |d|
      procedures << d unless d.nil?
    end
    procedures
  end
  
  #ZOMFG write some documentation for this >.<
  def hash_to_java_array(hash, length, is_diagnoses)
		result = []
		tmp = []
		length.times {result << nil}
		result = result.to_java(:string)
		
		if is_diagnoses		
			hash.each do |key, value| 
				tmp << value.gsub(/\./, "").strip unless value.blank?
			end
		else
			hash.each do |key, value| 
				# tmp_procedure contains the current procedure value
				tmp_procedure = ""
				counter = 0				
				value.each do |key2, value2|
					# we use ":" as our string delimiter symbol
					if counter == 0 && !value2.blank?
					  tmp_procedure += value2.gsub(/\./, "").strip
					else 
					 tmp_procedure += value2
					end
					if counter < 2
						tmp_procedure += ":"
					end
					counter = counter + 1 			
				end
				tmp << tmp_procedure unless tmp_procedure == "::"
			end
		end

		tmp_java_array = tmp.to_java(:string)
		(0..(tmp_java_array.size-1)).each {|i| result[i] = tmp_java_array[i]}
		result
	end
	
	def manual_submission=(submission)
	 @manual_submission = submission
	end
	
	def manual_submission
	 @manual_submission
	end
  
  private
  
  # 'age_mode' is chosen in the form and can be
  # either 'days' or 'years'.
  # @return true if the age is given in days, false if the age is given in years. 
  def age_mode_days?
    age_mode == 'days'
  end
  
  def today
    Time.now
  end
end
