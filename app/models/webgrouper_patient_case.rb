class WebgrouperPatientCase
  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :entry_date, :exit_date, :birth_date, :leave_days, :age_years, :age_days, :adm_weight, :sex, :pdx, :diagnoses, :procedures
  
  validates :age_years, :presence => true
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
end