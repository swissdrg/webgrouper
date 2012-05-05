# WebgrouperPatientCase holds all input variables for a certain patient case
# you can find in either the entry date, the exit date and the number of leave days. 
# WebgrouperPatientCase inherits from the java class PatientCase
class WebgrouperPatientCase < PatientCase
  
  include ActAsValidGrouperQuery
  
  attr_accessor :age, :age_mode, :house, :manual_submission
  
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
      value = value.to_i if send(name).is_a? Fixnum
      send("#{name}=", value) 
    end
    
    age_mode_days? ? self.age_days = self.age : self.age_years = self.age
  end
  
  # Always returns false since this model is not persisted (saved in a database).
  # The method is necessary for this model to be treated like an active record model
  # in certain circumstances; when building forms, for instance.
  def persisted?
    false
  end
  
  # Custom setter for pdx (main diagnosis)
  # Makes sure that the variable pdx only references a short code representation of an 
  # icd code by filtering out periods and whitespace.
  def pdx=(pdx)
    set_pdx pdx.gsub(/\./, "").strip
  end
  
  def pdx
    ICD.pretty_code_of get_pdx
  end

  def diagnoses=(diagnoses)
	  set_diagnoses hash_to_java_array(diagnoses, 99, true)
  end
  
  def diagnoses
    diagnoses = []
    get_diagnoses.each do |d|
      diagnoses << ICD.pretty_code_of(d) unless d.nil?
    end
    diagnoses
  end

  def procedures=(procedures)
		set_procedures hash_to_java_array(procedures, 100, false)
  end
  
  def procedures
    procedures = []
    get_procedures.each do |d|
      unless d.nil?
        d = d.match(/(\S*)\:(\w*)\:(\w*)/)[1]
        procedures << OPS.pretty_code_of(d) 
      end
    end
    procedures
  end
  
  #   def hash_to_java_array(hash, length, is_diagnoses)
  #   result = []
  #   tmp = []
  #   length.times {result << nil}
  #   result = result.to_java(:string)
  #   
  #   if is_diagnoses   
  #     hash.each do |key, value| 
  #       tmp << value.gsub(/\./, "").strip unless value.blank?
  #     end
  #   else
  #     hash.each do |key, value| 
  #       # tmp_procedure contains the current procedure value
  #       tmp_procedure = ""
  #       counter = 0       
  #       value.each do |key2, value2|
  #         # we use ":" as our string delimiter symbol
  #         if counter == 0 && !value2.blank?
  #           tmp_procedure += value2.gsub(/\./, "").strip
  #         elsif counter == 2 && !value2.blank?
  #           regexed_date = value2.match(/(.*)\.(.*)\.(.*)/) 
  #           unless regexed_date.nil?
  #             tmp_procedure += regexed_date[3] + regexed_date[2] + regexed_date[1] 
  #           else
  #             tmp_procedure += value2
  #           end
  #         else 
  #          tmp_procedure += value2
  #         end
  #         if counter < 2
  #           tmp_procedure += ":"
  #         end
  #         counter = counter + 1       
  #       end
  #       tmp << tmp_procedure unless tmp_procedure == "::"
  #     end
  #   end
  # 
  #   tmp_java_array = tmp.to_java(:string)
  #   (0..(tmp_java_array.size-1)).each {|i| result[i] = tmp_java_array[i]}
  #   result
  # end
  
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
