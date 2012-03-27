# WebgrouperPatientCase holds all input variables for a certain patiant case
# you can find in either the entry date, the exit date and the number of leave days. 
# WebgrouperPatientCase inherits from the java class PatientCase
# autors team1
class WebgrouperPatientCase < PatientCase
  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  
  attr_accessor :age,
                :age_mode
  
  validates :sex,             :presence => true
  validates_date :entry_date,      :on_or_before => :today, :allow_blank => true
  validates_date :exit_date,       :on_or_before => :today, :after => :entry_date, :allow_blank => true
  validates_date :birth_date,      :on_or_before => :today, :allow_blank => true
  validates :leave_days,      :numericality => { :only_integer => true, :greater_than_or_equal_to => 0}
  validates :age,             :presence => true, :numericality => { :only_integer => true, :greater_than => 0, :less_than => 125}, :unless => :age_mode_days?
  validates :age,             :presence => true, :numericality => { :only_integer => true, :greater_than => 0, :less_than => 367}, :if => :age_mode_days?
  validates :age_years,       :presence => true
  validates :age_days,        :presence => true
  validates :adm_weight,      :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 250, :less_than_or_equal_to => 20000}, :if => :age_mode_days?
  #Admission mode
  validates :adm,             :presence => true
  #Separation mode
  validates :sep,             :presence => true
  #Length of stay
  validates :los,             :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0}
  #artificial respiration time
  validates :hmv,             :numericality => { :only_integer => true, :greater_than_or_equal_to => 0}
  # validates :pdx,             :presence => true
  # validates :diagnoses,       :presence => true
  # validates :procedures,      :presence => true
  
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
  
  def persisted?
    false
  end

  def diagnoses=(diagnoses)
	  set_diagnoses hash_to_java_array(diagnoses, 99)
  end

  def procedures=(procedures)
		set_procedures hash_to_java_array(procedures, 100)
  end
  
  def hash_to_java_array(hash, length)
		result = []
		tmp = []
		length.times {result << nil}
		result = result.to_java(:string)
  	hash.each do |key, value| 
			tmp << value unless value.blank? 
		end
		tmp_java_array = tmp.to_java(:string)
		(0..(tmp_java_array.size-1)).each {|i| result[i] = tmp_java_array[i]}
		result
	end
  
  private
  
  def age_mode_days?
    age_mode == 'days'
  end
  
  def today
    Time.now
  end
end
