#Validates if an ops code can be found in the database.
class ExistingChopValidator < ActiveModel::EachValidator
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
      if(!short_code.empty? && !Chop.exists?(record.system_id, short_code))
        record.errors[attribute] << "#{short_code} invalid"
      end
    end
  end
  
  private
  
  def no_code_entered?(short_code, laterality, date)
    short_code.blank? && ( !laterality.blank? || !date.gsub("/\./", "").blank? )
  end
end