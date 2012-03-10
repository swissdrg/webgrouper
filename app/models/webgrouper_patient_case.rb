class WebgrouperPatientCase
  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :entry_date, 
                :exit_date,
                :birth_date, 
                :leave_days, 
                :age_years, 
                :age_days, 
                :adm_weight, 
                :sex, 
                :adm, 
                :sep,
                :los,
                :sdf,
                :hmv, 
                :pdx, 
                :diagnoses,
                :procedures
  
  #TODO: Add more validations
  validates :age_years, :presence => true
  validates :sex,       :presence => true
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
  def self.wrapper_patient_case_for(attributes = {})
    patient_case = PatientCase.new
    prepare_for_grouping(patient_case, attributes) do |name, value|
      patient_case.send("set_#{name}", value) unless value.nil?
    end
    patient_case
  end
  
  
  private
    
    def self.prepare_for_grouping(patient_case, attributes = {}, &block)
      attributes.each do |name, value|
        if patient_case.send(name).is_a? Fixnum
          value = value.to_i 
        end
        yield name, value
      end
    end
  
end