class ExistingIcdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    short_code = value.gsub(/\./, "").strip
    record.errors[attribute] << "invalid" if ICD.find_by_IcShort(short_code).nil?
  end
end