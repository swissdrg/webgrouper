#Validates if an icd code can be found in the database.
class ExistingIcdValidator < ActiveModel::EachValidator
  #will automatically be called if one should validate existing_icd as true
  def validate_each(record, attribute, value)
    unless value.blank?
      if value.is_a?(String)
        validate_diagnoses(record, attribute, value)
      else
        value.each {|v| validate_diagnoses(record, attribute, v) }
      end
    end
  end

  private

  def validate_diagnoses(record, attribute, value)
    short_code = Icd.short_code_of(value)
    record.errors[attribute] << "#{value} invalid" unless record.system.icds.where(code_short: short_code).exists?
  end

end