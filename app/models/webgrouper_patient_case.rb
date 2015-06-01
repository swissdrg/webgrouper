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
  attr_accessor :age_mode, :age_mode_decoy, :id

  # The default swissdrg format with additional data in the id-field, split by semicolon if readable is set to false
  # and split by underscore if readable is set to true
  def to_s
    # additional information from id field
    s = [self.system_id, self.birth_date, self.entry_date, self.exit_date, self.leave_days].join('_')
    # rest of string
    # TODO
    return s
  end

  def to_swissdrg_s
    to_s.gsub('-', ';')
  end

  FORM_DATE_FORMAT = "%d.%m.%Y"
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
    age_years = pc_array[1]
    age_days = pc_array[2]
    if params[:age_years].blank?
      params[:age_mode_decoy] = params[:age_mode] = 'days'
      params[:age] = age_days
    else
      params[:age_mode_decoy] = params[:age_mode] = 'years'
      params[:age] = age_years
    end
    params[:adm_weight] = pc_array[3]
    params[:sex] = pc_array[4]
    params[:adm] = pc_array[5]
    params[:sep] = pc_array[6]
    params[:los] = pc_array[7]
    params[:sdf] = pc_array[8]
    params[:hmv] = pc_array[9]
    params[:pdx] = pc_array[10]

    params[:diagnoses] = pc_array[(11...(11+99))].reject &:blank?
    params[:procedures] = pc_array[110...(110+100)]
                              .reject(&:blank?)
                              .map{ |p| p.split(':') }
                              .map{ |p_arry| { 'c' => p_arry[0],
                                               'l' => (p_arry[1] || '').upcase,
                                               'd' => (Date.strptime(p_arry[2], GROUPER_DATE_FORMAT).strftime(FORM_DATE_FORMAT) rescue '')}}
    params.each do |key, value|
        params.delete(key) if value.blank?
    end
    WebgrouperPatientCase.new(params)
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
  java_import org.swissdrg.grouper.Procedure

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
    pc.birth_date = exit_date.strftime(GROUPER_DATE_FORMAT) unless birth_date.blank?
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
    return supplement_procedures
  end

  private

  # Removes empty values from arrays.
  def trim_arrays
    self.system_id ||= DEFAULT_SYSTEM
    self.diagnoses.reject! &:blank?
    self.procedures.reject! {|p| p.values.all? &:blank? }
  end

end
