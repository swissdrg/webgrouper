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
  validates :sex,             :presence => true
  validates :age_years,       :presence => true, :numericality => { :only_integer => true }
  validates :entry_date,      :presence => true
  validates :entry_date,      :presence => true
  validates :exit_date,       :presence => true
  validates :birth_date,      :presence => true
  validates :leave_days,      :presence => true
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
  
            
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end
  
  #TODO: Find a cleaner and DRY way of matching a webgrouper patient case to a wrapper patient case
  def wrapper_patient_case
    pc = PatientCase.new
    pc.entry_date = entry_date unless entry_date.nil?
    pc.exit_date = exit_date unless exit_date.nil?
    pc.birth_date = birth_date unless birth_date.nil?
    pc.leave_days = leave_days.to_i unless leave_days.nil?
    pc.age_years = age_years.to_i unless age_years.nil?
    pc.age_days = age_days.to_i unless age_days.nil?
    pc.adm_weight = adm_weight unless adm_weight.nil?
    pc.sex = sex unless sex.nil?
    pc.adm = adm unless adm.nil?
    pc.sep = sep unless sep.nil?
    pc.los = los.to_i unless los.nil?
    pc.sdf = sdf unless sdf.nil?
    pc.hmv = hmv.to_i unless hmv.nil?
    pc.pdx = pdx unless pdx.nil?
    pc.diagnoses = diagnoses unless diagnoses.nil?
    pc.procedures = procedures unless diagnoses.nil?
    
    pc
  end
  
end