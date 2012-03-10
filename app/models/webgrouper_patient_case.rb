class WebgrouperPatientCase < PatientCase
  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  #TODO: Add more validations
  validates :age_years, :presence => true
  validates :sex,       :presence => true
  
  def initialize(attributes = {})
    super()
    prepare_for_grouping(attributes = {}) do |name, value|
      send("#{name}=", value)
    end
  end
  
  private
  
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