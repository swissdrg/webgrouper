# WebgrouperPatientCase holds all input variables for a certain patiant case
# you can find in either the entry date, the exit date and the number of leave days. 
# WebgrouperPatientCase inherits from the java class PatientCase
# autors team1
class WebgrouperPatientCase < PatientCase
  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :age,
                :age_mode
                
  #TODO: Add more validations
  validates :sex,             :presence => true
  #validate_age
  validates :entry_date,      :presence => true
  validates :exit_date,       :presence => true
  validates :birth_date,      :presence => true
  validates :leave_days,      :presence => true, :numericality => { :only_integer => true, :greater_than => 0}
  validates :age_years,       :presence => true
  validates :age_days,        :presence => true
  validates :adm_weight,      :presence => true
  validates :adm,             :presence => true
  validates :sep,             :presence => true
  validates :los,             :presence => true
  # validates :sdf,             :presence => true
  # validates :hmv,             :presence => true
  # validates :pdx,             :presence => true
  # validates :diagnoses,       :presence => true
  # validates :procedures,      :presence => true
  
  # invokes superconstructor of java class PatientCase
	# prepares values of attribute hash for the ruby patient class.
  def initialize(attributes = {})
    super()
    if age_mode == "years"
      self.age_years = self.age
    else
      self.age_days = self.age
    end
    
    attributes.each do |name, value|
      if send(name).is_a? Fixnum
        value = value.to_i 
      end
      if name == "diagnoses" || name == "procedures"
        temp = []
        name == "procedures" ? length = 100 : length = 99
        length.times {temp << nil}
        tmp1 = temp.to_java(:string)
        tmp = [value].to_java(:string)
        (0..(tmp.size-1)).each {|i| tmp1[i] = tmp[i]}
        send("set_#{name}", tmp1)
      end
      send("#{name}=", value) unless name == "diagnoses" || name == "procedures"
    end
  end
  
  def persisted?
    false
  end
  
  def validate_age
    if age_mode == "years"
    validates :age,             :presence => true, :numericality => { :only_integer => true,
       :greater_than => 0, :smaller_than => 125}
    else 
    validates :age,             :presence => true, :numericality => { :only_integer => true,
       :greater_than => 0, :smaller_than => 266}
    end
  end
end
