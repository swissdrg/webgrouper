class WebgrouperPatientCase
  include Mongoid::Document
  include Mongoid::Timestamps

  after_initialize :trim_arrays

  # System
  field :system_id, type: Integer, default: DEFAULT_SYSTEM
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

  # Additional stuff:
  field :valid_case, type: Boolean

  include ActAsValidGrouperQuery
  attr_accessor :age_mode, :age_mode_decoy, :house, :manual_submission, :id

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

  # Takes a SwissDRG-string as input and returns the complying WebgrouperPatientCase.
  # the swissdrg-string may also be split by dashes instead of semicolons.
  # The ID field is further used to encode data usually not contained in a SwissDRG string.
  # TODO: rewrite
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
    params[:age_years] = pc_array[1] unless pc_array[1] == '0'
    params[:age_days] = pc_array[2] unless pc_array[2] == '0'
    if params[:age_years].blank?
      params[:age_mode_decoy] = params[:age_mode] = 'days'
      params[:age] = params[:age_days]
    else
      params[:age_mode_decoy] = params[:age_mode] = 'years'
      params[:age] = params[:age_years]
    end
    params[:admWeight] = pc_array[3]
    params[:sex] = pc_array[4]
    params[:adm] = pc_array[5]
    params[:sep] = pc_array[6]
    params[:los] = pc_array[7]
    params[:sdf] = pc_array[8]
    params[:hmv] = pc_array[9]
    params[:pdx] = pc_array[10]

    params[:diagnoses] = {}
    (1..99).each do |number|
      diagnosis = pc_array[number + 10]
      params[:diagnoses][number.to_s] = diagnosis unless diagnosis.blank?
    end

    params[:procedures] = {}
    (0...100).each do |number|
      procedure = pc_array[number + 110]
      next if procedure.blank? #skip if no procedure given
      elements = procedure.split(':')
      params[:procedures][number.to_s] = {}
      (0..2).each do |element_nr|
        #convert date to standard german format
        if (element_nr == 2 and not elements[2].blank?)
          element = "#{elements[2][6..7]}.#{elements[2][4..5]}.#{elements[2][0..3]}"
        else
          element = elements[element_nr] || ''
        end
        params[:procedures][number.to_s][element_nr.to_s] = element
      end
    end
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

  GROUPER_DATE_FORMAT = "yyyyMMdd"

  # Turns this instance of a webgrouper patient case into a java patient case that can be grouped by the java grouper.
  def to_java
    pc = PatientCase.new
    pc.birth_house = care_taker_birth_house?

    # Stay
    pc.entry_date = entry_date.strftime(GROUPER_DATE_FORMAT) unless entry_date.blank?
    pc.exit_date = exit_date.strftime(GROUPER_DATE_FORMAT) unless entry_date.blank?
    pc.leave_days = leave_days
    pc.adm = adm
    pc.sep = sep
    pc.los = los

    # Patient data
    pc.sex = sex
    pc.birth_date = exit_date.strftime(GROUPER_DATE_FORMAT) unless entry_date.blank?
    if age_mode_days?
      pc.age_days = age
    else
      pc.age_years = age
    end
    pc.adm_weight = adm_weight
    pc.hmv = hmv

    # Diagnoses and procedures
    pc.pdx = Diagnosis.new(pdx)
    pc.diagnoses = diagnoses.map { |d| Diagnosis.new(d) }
    pc.procedures = procedures.map {|p| Procedure.new(p.values.join(':')) }
    pc
  end

  # Creates a hash which contains, if there are any, procedures relevant for zusatzentgelte
  # the hash contains the appropriate fee, description, amount of the fee, and the number of appearances
  # of the same procedure which entered the user as values and as key a procedure code.
  # furthermore this method calculates also the total supplement amount (summed up).
  def get_supplements
    supplement_procedures = {}
    total_supplement_amount = 0
    self.procedures.each do |p|
      # cleanup: we just want the procedure code (no seitigkeit or date)
      p = p['c']
      # if there is an a row in supplementops which has a column equals the given procedure value
      # prepare hash for a new value
      sup = Supplement.in_system(self.system_id).where(:chop_atc_code => p).first
      unless sup.nil?
        code = sup.supplement_code
        amount = sup.amount
        description = sup.text
        total_supplement_amount += amount

        # count how many times the same proc appeared with same fee.
        default_proc_count = 1
        if supplement_procedures[p].nil?
          data = {
              :fee => code,
              :description => description,
              :amount => amount,
              :proc_count => default_proc_count,
              :age_max => sup.age_max
          }
          supplement_procedures[p] = data
        else
          supplement_procedures[p][:proc_count] += 1
        end

      end
    end
    return supplement_procedures, total_supplement_amount
  end


  private

  # Removes empty values from arrays.
  def trim_arrays
    self.diagnoses.reject! &:blank?
    self.procedures.reject! {|p| p.values.all? &:blank? }
  end

end
