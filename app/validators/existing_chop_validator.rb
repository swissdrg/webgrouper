#Validates if an ops code can be found in the database.
class ExistingChopValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value.each_with_index do |v, i|
      code = v['c']
      short_code = Chop.short_code_of(code)
      laterality = v['l']
      date = v['d']
      if no_code_entered?(short_code, laterality, date)
        record.errors[attribute] << I18n.t("errors.messages.no_code")
        record.errors[attribute][0] += " #{laterality}" unless laterality.blank?
        record.errors[attribute][0] += " #{date}" unless date.gsub('.', '').blank?
      end     
      if !short_code.blank?
        begin
          chop = record.system.chops.find_by(code_short: short_code)
          record.chops[i] = chop
          # Replace code with pretty code
          v['c'] = chop.code
        rescue Mongoid::Errors::DocumentNotFound => e
          record.errors[attribute] << "#{code} invalid"
        end
      end
    end
  end
  
  private
  
  def no_code_entered?(short_code, laterality, date)
    short_code.blank? && ( !laterality.blank? || !date.gsub('.', '').blank? )
  end
end