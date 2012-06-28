#Validates if an icd code can be found in the database.
class ExistingIcdValidator < ActiveModel::EachValidator
  #will automatically be called if one should validate existing_icd as true
  def validate_each(record, attribute, value)
    unless value.blank?
      value.is_a?(String) ? validate_pdx(record, attribute, value) : validate_diagnoses(record, attribute, value)
    end
  end

  private

  def validate_pdx(record, attribute, value)
    record.errors[attribute] << "invalid" unless ICD.exists?(record.system_id, value)
  end

  def validate_diagnoses(record, attribute, value)
    value.each do |v|
      record.errors[attribute] << "#{v} invalid" unless ICD.exists?(record.system_id, v)
    end
  end


end