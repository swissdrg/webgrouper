#Validates if an ops code can be found in the database.
class ExistingChopValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value.each do |v|
      short_code = v['c'].gsub('.', '').strip
      laterality = v['l']
      date = v['d']
      if no_code_entered?(short_code, laterality, date)
        record.errors[attribute] << I18n.t("errors.messages.no_code")
        record.errors[attribute][0] += " #{laterality}" unless laterality.blank?
        record.errors[attribute][0] += " #{date}" unless date.gsub('.', '').blank?
      end     
      if !short_code.blank? && !Chop.exists?(record.system_id, short_code)
        record.errors[attribute] << "#{short_code} invalid"
      end
    end
  end
  
  private
  
  def no_code_entered?(short_code, laterality, date)
    short_code.blank? && ( !laterality.blank? || !date.gsub('.', '').blank? )
  end
end