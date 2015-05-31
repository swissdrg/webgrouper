#Validates if an icd code can be found in the database.
class ExistingIcdValidator < ActiveModel::EachValidator
  #will automatically be called if one should validate existing_icd as true
  def validate_each(record, attribute, value)
    unless value.blank?
      if value.is_a?(String)
        icd = validate_diagnoses(record, attribute, value, 0)
        # Set pdx to pretty code if exists.
        record.send("#{attribute}=", icd.code) unless icd.nil?
      else
        value.each_with_index do |v, i|
          icd = validate_diagnoses(record, attribute, v, i + 1)
          # Set diagnosis to pretty code if exists.
          record.send(attribute).send("[]=", i, icd.code) unless icd.nil?
        end
      end
    end
  end

  private

  def validate_diagnoses(record, attribute, value, idx)
    short_code = Icd.short_code_of(value)
    begin
      icd = record.system.icds.find_by(code_short: short_code)
      # Cache icd for later use
      record.icds[idx] = icd
      icd
    rescue Mongoid::Errors::DocumentNotFound => e
      record.errors[attribute] << "#{value} invalid"
      nil
    end
  end

end