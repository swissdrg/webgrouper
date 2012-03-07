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
  
  validates :age_years, :presence => true
  validates :sex,       :presence => true
  
  def initialize(attributes = {})
    diagnoses = []
    procedures = []
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
  def wrapper_patient_case
    pc = PatientCase.new
    pc.entry_date = entry_date unless entry_date.nil?
    pc.exit_date = exit_date unless exit_date.nil?
    pc.birth_date = birth_date unless birth_date.nil?
    pc.leave_days = leave_days unless leave_days.nil?
    pc.age_years = age_years unless age_years.nil?
    pc.age_days = age_days unless age_days.nil?
    pc.adm_weight = adm_weight unless adm_weight.nil?
    pc.sex = sex unless sex.nil?
    pc.adm = adm unless adm.nil?
    pc.sep = sep unless sep.nil?
    pc.los = los unless los.nil?
    pc.sdf = sdf unless sdf.nil?
    pc.hmv = hmv unless hmv.nil?
    pc.pdx = pdx unless pdx.nil?
    pc.diagnoses = diagnoses
    pc.procedures = procedures
    
    pc
  end
  
end