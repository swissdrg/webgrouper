class ExistingIcdValidator < ActiveModel::EachValidator
  #will automatically be called if one should validate existing_icd as true
  def validate_each(record, attribute, value)
    value.is_a?(String) ? validate_pdx(record, attribute, value) : validate_diagnoses(record, attribute, value)
  end
  
  def validate_pdx(record, attribute, value)
    short_code = short_code_of(value)
    record.errors[attribute] << "invalid" if ICD.find_by_IcShort(short_code).nil?
  end
  
  def validate_diagnoses(record, attribute, value)
    value.each do |v|
      short_code = short_code_of(v) unless v.blank?
      record.errors[attribute] << "#{v} invalid\n" if ICD.find_by_IcShort(short_code).nil?
    end
  end
  
  def short_code_of(value)
    value.gsub(/\./, "").strip
  end
  
end