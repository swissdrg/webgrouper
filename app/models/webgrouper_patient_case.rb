# WebgrouperPatientCase holds all input variables for a certain patient case
# you can find in either the entry date, the exit date and the number of leave days. 
# WebgrouperPatientCase inherits from the java class PatientCase
class WebgrouperPatientCase < PatientCase
  
  include ActAsValidGrouperQuery
  attr_accessor :age, :age_mode, :age_mode_decoy, :house, :manual_submission, :system_id, :id
  # invokes super constructor of java class PatientCase
	# prepares values of attribute hash for the ruby patient class.
  def initialize(attributes = {})
    super()  
    # initialize attributes to display correct default values in view
    self.age = 40
    self.los = 10
    self.birth_date = ''
    self.entry_date = ''
    self.exit_date = ''
    self.adm_weight = 4000
	  self.adm = '99' #aka unknown
    self.sep = '99' #aka unknown
    self.pdx = ''
    self.system_id = DEFAULT_SYSTEM
    
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
    super(Icd.short_code_of(pdx))
  end
  
  # Custom getter for pdx
  # Makes sure that it appears in the form as pretty code
  def pdx
    Icd.pretty_code_of(system_id, super) rescue get_pdx
  end

  def diagnoses=(diagnoses)
	  set_diagnoses hash_to_java_array(diagnoses, 99, true)
  end
  
  def diagnoses
    diagnoses = []
    get_diagnoses.each do |d|
      unless d.nil?
        begin
          diagnoses << Icd.pretty_code_of(system_id, d)
        rescue
          diagnoses << d
        end
      end
    end
    diagnoses
  end

  def procedures=(procedures)
		set_procedures hash_to_java_array(procedures, 100, false)
  end
  
  def procedures
    procedures = []
    get_procedures.each do |p|
      unless p.nil?
        regex = /(\S*)\:(\w*)\:(\w*)/
        short_code = p.match(regex)[1]
        laterality = p.match(regex)[2]
        date = p.match(regex)[3]
        begin
          code = Chop.pretty_code_of(system_id, short_code)
        rescue
          code = short_code
        end
        parsed_date = "#{date[6..7]}.#{date[4..5]}.#{date[0..3]}"
        p = "#{code}:#{laterality}:#{parsed_date}"
        procedures << p
      end
    end
    procedures
  end

  # The default swissdrg format with additional data in the id-field, split by semicolon if readable is set to false
  # and split by underscore if readable is set to true
  def to_s
    # additional information from id field
    s = [self.system_id, self.birth_date, self.entry_date, self.exit_date, self.leave_days].join('_')
    # rest of string
    s << super.to_s
    s.gsub!(';','-')
    return s
  end

  def to_swissdrg_s
    to_s.gsub('-', ';')
  end

  # Takes a SwissDRG-string as input and returns the complying WebgrouperPatientCase.
  # the swissdrg-string may also be split by dashes instead of semicolons.
  # The ID field is further used to encode data usually not contained in a SwissDRG string.
  def self.parse(pc_string)
    params = {}
    if pc_string.include? (';')
      pc_array = pc_string.split(';')
    else
      pc_array = pc_string.split('-')
    end

    additional_data = pc_array[0].split('_')
    if additional_data.size == 5 # for legacy support
      params[:system_id] = additional_data[0]
      params[:birth_date] = additional_data[1]
      params[:entry_date] = additional_data[2]
      params[:exit_date] = additional_data[3]
      params[:leave_days] = additional_data[4]
    end
    params[:age_years] = pc_array[1] unless pc_array[1] == '0'
    params[:age_days] = pc_array[2] unless pc_array[2] == '0'
    if params[:age_years].blank?
      params[:age_mode_decoy] = params[:age_mode] = 'days'
      params[:age] = params[:age_days]
    else
      params[:age_mode_decoy] = params[:age_mode] = 'years'
      params[:age] = params[:age_years]
    end
    params[:admWeight] = pc_array[3]
    params[:sex] = pc_array[4]
    params[:adm] = pc_array[5]
    params[:sep] = pc_array[6]
    params[:los] = pc_array[7]
    params[:sdf] = pc_array[8]
    params[:hmv] = pc_array[9]
    params[:pdx] = pc_array[10]

    params[:diagnoses] = {}
    (1..99).each do |number|
      diagnosis = pc_array[number + 10]
      params[:diagnoses][number.to_s] = diagnosis unless diagnosis.blank?
    end

    params[:procedures] = {}
    (0...100).each do |number|
      procedure = pc_array[number + 110]
      next if procedure.blank? #skip if no procedure given
      elements = procedure.split(':')
      params[:procedures][number.to_s] = {}
      (0..2).each do |element_nr|
        #convert date to standard german format
        if (element_nr == 2 and not elements[2].blank?)
          element = "#{elements[2][6..7]}.#{elements[2][4..5]}.#{elements[2][0..3]}"
        else
          element = elements[element_nr] || ''
        end
        params[:procedures][number.to_s][element_nr.to_s] = element

      end
    end
    params.each do |key, value|
        params.delete(key) if value.blank?
    end
    WebgrouperPatientCase.new(params)
  end
  
  private

	# convert a given ruby hash to a java array of fixed size
	# either of size 99 (i.e. diagnoses) or 100 (i.e. procedures)
	# and fill resulting java array with given inpuit which is stored in the arguemnt hash
  def hash_to_java_array(hash, length, is_diagnoses)
    empty_ruby_array = []
    tmp_ruby_array = []
    length.times {empty_ruby_array << nil}
    java_array = empty_ruby_array.to_java(:string)
    
    if is_diagnoses   
    	hash.each do |key, value| 
      	tmp_ruby_array << value.gsub(/\./, "").strip unless value.blank?
      end
    else
			fill_and_filter_java_array(hash, tmp_ruby_array)
    end
  
    tmp_java_array = tmp_ruby_array.to_java(:string)
		# since indicess start at 0 the last index of an array with n elements is (n-1)
	  # therefore this each block
    (0..(tmp_java_array.size-1)).each {|i| java_array[i] = tmp_java_array[i]}
    java_array
  end
	
	# helper method for the method hash_to_java_array
	# in the case we are considering not diagnoses,
	# i.e. we are considering procedures.
	# filters given input(and adds : delimiter)
	# and stores it in a java_array.
	# a procedure is a tripple (A:B:C) which has as first element
	# a procedure as 2nd element a seitigkeit, and as 
  # 3rd element a data for the given procedure.
	# remark: B and C may be empty string for a given A
	# filter all the . out of an A to get its short code
	# rearange the date since the date format of the grouper is yyyy.mm.dd
	def fill_and_filter_java_array(hash, tmp_ruby_array)
		hash.each do |tripple_key, tripple| 
    	# tmp_procedure contains the current procedure value
      tmp_procedure = ""
			     
			# a tripple element is either a procedure code, laterality or a date
			# except procedure code(i.e. counter == 0) all other tripple elements may be blank
      tripple.each do |element_key, tripple_element|
				counter = element_key.to_i
		    # we use ":" as our string delimiter symbol
		    if counter == 0 && !tripple_element.blank?
		    	tmp_procedure += tripple_element.gsub(/\./, "").strip
		    elsif counter == 2 && !tripple_element.blank?
		      regexed_date = tripple_element.match(/(.*)\.(.*)\.(.*)/) 
		      unless regexed_date.nil?
		      	tmp_procedure += regexed_date[3] + regexed_date[2] + regexed_date[1] 
		      else
		        tmp_procedure += tripple_element
		      end
		    else 
		      tmp_procedure += tripple_element
		    end

		    if counter < 2
		    	tmp_procedure += ":"
		    end
		    
			end
    	tmp_ruby_array << tmp_procedure unless tmp_procedure == "::"
		end	
	end

  # 'age_mode' is chosen in the form and can be
  # either 'days' or 'years'.
  # @return true if the age is given in days, false if the age is given in years. 
  def age_mode_days?
    self.age_mode == 'days'
  end
  
  # @return true if birthhouse was chosen as care supplier. 
  def care_taker_birth_house?
    self.house == '2'
  end
  
  def today
    Time.now
  end
  
end
