class ExistingOpsValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    procedure_checker(value)
  end

private
	def procedure_checker(record, attribute, value)
		error_happened = false
		value.each do |item| 
			short_code = string.match(/(\w*)\$(\w*)\$(\w*)/)[1]
			error_happened = OPS.find_by_OpShort(short_code).nil?
			if(error_happened)
				error_msg = ""
				error_msg = short_code unless short_code.empty?
				record.errors[attribute] << error_msg
			end
		end
	end
