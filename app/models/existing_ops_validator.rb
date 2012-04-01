#Validates if an ops code can be found in the database.
class ExistingOpsValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    procedure_checker(record, attribute, value)
  end

private
	def procedure_checker(record, attribute, value)
		error_happened = false
		value.each do |v| 
			short_code = v.match(/(\w*)\$(\w*)\$(\w*)/)[1].gsub(/\./, "").strip
			error_happened = OPS.find_by_OpShort(short_code).nil?
			if(error_happened)
				error_msg = ""
				error_msg = short_code unless short_code.empty?
				record.errors[attribute] << error_msg unless error_msg.blank?
			end
		end
	end
end