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

  private

  # Removes empty values from arrays.
  def trim_arrays
    self.diagnoses.reject! &:blank?
    self.procedures.reject! &:blank?
  end
end
