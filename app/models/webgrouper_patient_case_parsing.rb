class WebgrouperPatientCaseParsing
  include ActiveModel::Model
  attr_accessor :parse_string
  attr_accessor :system_id
  attr_accessor :house

  validates_presence_of :parse_string
  validates_with ParseStringValidator

  FORM_DATE_FORMAT = "%d.%m.%Y"

  def initialize(attributes = {})
    super(attributes)
    self.system_id ||= WebgrouperPatientCase::DEFAULT_SYSTEM
  end

  def system
    System.find_by(system_id: self.system_id)
  end

  # Takes a SwissDRG-string as input and returns the complying WebgrouperPatientCase.
  # the swissdrg-string may also be split by dashes instead of semicolons.
  # The ID field is further used to encode data usually not contained in a SwissDRG string.
  def to_patient_case
    params = {}
    if parse_string.include? (';')
      pc_array = parse_string.split(';', 211)
    else
      pc_array = parse_string.split('-', 211)
    end

    additional_data = pc_array[0].split('_')
    if additional_data.size == 5 # for legacy support
      params[:system_id] = additional_data[0]
      params[:birth_date] = additional_data[1]
      params[:entry_date] = additional_data[2]
      params[:exit_date] = additional_data[3]
      params[:leave_days] = additional_data[4]
    end
    params[:system_id] ||= self.system_id
    params[:house] ||= self.house
    age_years = pc_array[1]
    age_days = pc_array[2]
    # If age_years blank or 0, we assume it's not given.
    if age_years.to_i == 0
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
    # This is not used.
    # params[:sdf] = pc_array[8]
    params[:hmv] = pc_array[9]
    params[:pdx] = pc_array[10]

    params[:diagnoses] = pc_array[(11...(11+99))].reject &:blank?
    params[:procedures] = pc_array[110...(110+100)]
                              .reject(&:blank?)
                              .map { |p| p.split(':') }
                              .map { |p_arry| {'c' => p_arry[0],
                                               'l' => (p_arry[1] || '').upcase,
                                               'd' => (Date.strptime(p_arry[2], GROUPER_DATE_FORMAT).strftime(FORM_DATE_FORMAT) rescue '')} }
    params.each do |key, value|
      params.delete(key) if value.blank?
    end
    WebgrouperPatientCase.new(params)
  end
end