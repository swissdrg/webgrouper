# WebgrouperPatientCase holds all input variables for a certain patiant case
# you can find in either the entry date, the exit date and the number of leave days. 
# WebgrouperPatientCase inherits from the java class PatientCase
# autors team1
class WebgrouperPatientCase < PatientCase
  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  #TODO: Add more validations
  validates :age_years, :presence => true
  validates :sex,       :presence => true
  
  # invokes superconstructor of java class PatientCase
	# prepares values of attribute hash for the ruby patient class.
  def initialize(attributes = {})
    super()
    prepare_for_grouping(attributes = {}) do |name, value|
      send("#{name}=", value)
    end
  end
  
  private
  	
	  # cleans up attribute values and if necessary corrects data type
    def prepare_for_grouping(attributes = {}, &block)
      attributes.each do |name, value|
        if super.send(name).is_a? Fixnum
          value = value.to_i 
        end
        yield name, value
      end
    end
  
  def persisted?
    false
  end
  
end
