#Validates if an ops code can be found in the database.
class ExistingOpsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    error_happened = false
    value.each do |v|
      procedure_regex = /(\S*)\:(\w*)\:(\S*)/
      short_code = v.match(procedure_regex)[1].gsub(/\./, "").strip
      laterality = v.match(procedure_regex)[2]
      date = v.match(procedure_regex)[3]
      if no_code_entered?(short_code, laterality, date)
        record.errors[attribute] << I18n.t("errors.messages.no_code")
        record.errors[attribute][0] += " #{laterality}" unless laterality.blank?
        record.errors[attribute][0] += " #{date}" unless date.gsub("\.", "").blank?
      end
      error_happened = CHOP.exists?(short_code)
      if(error_happened)
        error_msg = ""
        error_msg = "#{short_code} invalid" unless short_code.empty?
        record.errors[attribute] << error_msg unless error_msg.blank?
      end
    end
  end
  
  private
  
  def no_code_entered?(short_code, laterality, date)
    short_code.blank? && ( !laterality.blank? || !date.gsub("/\./", "").blank? )
  end
end