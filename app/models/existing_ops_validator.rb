class ExistingOpsValidator < ActiveModel::EachValidator

#will automatically be called if one should validate existing_icd as true
attr_accessor :error_field

  def validate_each(record, attribute, value)
    short_code = value.gsub(/\./, "").strip
    record.errors[attribute] << "invalid" if procedure_checker(value)
  end

private

	def procedure_checker(value)
		error_happened = false
		value.each do |item| 
			original_string = item
			short_code = item.gsub(/\$/, "").strip 
			# finde  1. teil von item
			error_happened = OPS.find_by_IcShort(short_code).nil?
			if(error_happened) #save error in error_field, speichere item?
		end
		
		#save error msg
		error_happened
	end
