class WebgrouperPatientCase
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :system, primary_key: :system_id

  after_initialize :trim_arrays

  # System
  field :house, type: Integer

  # Stay
  field :entry_date, type: Date
  field :exit_date, type: Date
  field :leave_days, type: Integer, default: 0
  field :adm, type: String, default: '99' # aka unknown
  field :sep, type: String, default: '99' # aka unknown
  field :los, type: Integer, default: 10

  # Patient data
  field :sex, type: String
  field :birth_date, type: Date
  field :age, type: Integer, default: 40
  field :adm_weight, type: Integer, default: 4000
  field :hmv, type: Integer

  # Diagnoses and procedures
  field :pdx, type: String
  field :diagnoses, type: Array, default: []
  field :procedures, type: Array, default: []

  include ActAsValidGrouperQuery

  embeds_many :icds
  embeds_many :chops
  belongs_to :drg, primary_key: :code, foreign_key: :drg_code
  attr_accessor :age_mode, :age_mode_decoy
  attr_accessor :diagnoses_errors, :procedures_errors

  ADMISSION_MODES = %w(11 01 06 99)
  SEPARATION_MODES = %w(06 04 00 07 99)
  SEX_MODES = %w(M W U)

  # The default swissdrg format with additional data in the id-field,
  # split by underscore.
  def to_url_string
    # additional information from id field
    s = [self.system_id,
         self.birth_date.try(:strftime, WebgrouperPatientCaseParsing::FORM_DATE_FORMAT),
         self.entry_date.try(:strftime, WebgrouperPatientCaseParsing::FORM_DATE_FORMAT),
         self.exit_date.try(:strftime, WebgrouperPatientCaseParsing::FORM_DATE_FORMAT),
         self.leave_days].join('_')
    # rest of string
    s + to_java.to_s.gsub(';', '-')
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

  java_import org.swissdrg.grouper.PatientCase
  java_import org.swissdrg.grouper.Diagnosis

  GROUPER_DATE_FORMAT = "%Y%m%d"

  # Turns this instance of a webgrouper patient case into a java patient case that can be grouped by the java grouper.
  def to_java
    pc = PatientCase.new
    pc.birth_house = care_taker_birth_house?

    # Stay
    pc.entry_date = entry_date.strftime(GROUPER_DATE_FORMAT) unless entry_date.blank?
    pc.exit_date = exit_date.strftime(GROUPER_DATE_FORMAT) unless exit_date.blank?
    pc.leave_days = leave_days
    pc.adm = adm
    pc.sep = sep
    pc.los = los

    # Patient data
    pc.sex = sex
    pc.birth_date = birth_date.strftime(GROUPER_DATE_FORMAT) unless birth_date.blank?
    if age_mode_days?
      pc.age_days = age
    else
      pc.age_years = age
    end
    pc.adm_weight = adm_weight
    pc.hmv = hmv

    # Diagnoses and procedures
    pc.pdx = Diagnosis.new(pdx)
    pc.diagnoses = diagnoses
    pc.procedures = procedures.map {|p| p.values.join(':') }
    pc
  end

  # Creates a hash which contains, if there are any, procedures relevant for zusatzentgelte
  # the hash contains the appropriate fee, description, amount of the fee, and the number of appearances
  # of the same procedure which entered the user as values and as key a procedure code.
  # furthermore this method calculates also the total supplement amount (summed up).
  def get_supplements
    # We just want the procedure code (no seitigkeit or date)
    procedures_codes = procedures.map {|p| p['c'] }
    supplements = system.supplements.where(:chop_atc_code.in => procedures_codes )
    supplement_procedures = supplements.map do |sup|
      # count how many times the same proc appeared with same fee.
      proc_count = procedures_codes.select { |p| p == sup.chop_atc_code }.count
      {
          :chop_code => sup.chop_atc_code,
          :fee => sup.supplement_code,
          :description => sup.text,
          :amount => sup.amount * proc_count,
          :proc_count => proc_count,
          :age_max => sup.age_max
      }
    end
  end

  private

  # Removes empty values from arrays.
  def trim_arrays
    self.system_id ||= DEFAULT_SYSTEM
    self.diagnoses.reject! &:blank?
    self.procedures.reject! {|p| p.values.all? &:blank? }
    self.diagnoses_errors = []
    self.procedures_errors = []
  end

end
