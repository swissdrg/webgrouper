class ExistingIcdValidator < ActiveModel::EachValidator
  #will automatically be called if one should validate existing_icd as true
  def validate_each(record, attribute, value)
    short_code = value.gsub(/\./, "").strip
    record.errors[attribute] << "invalid" if ICD.find_by_IcShort(short_code).nil?
  end
end