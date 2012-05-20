class OPS < ActiveRecord::Base
	has_many :names, :class_name => "OPSName", :foreign_key => "OnFkOpID" 
  default_scope lambda{where(:OpFkSyID => System.current_system_id)}
	
	def OpName
		system_language = I18n.locale.to_s.upcase
		description = self.names.select{|name| name.OnLang == system_language}.first
		description ||= self.names.select{|name| name.OnLang == "DE"}.first
		description.OnName	
	end

  def self.table_name
    "ops"
  end
  
  def self.short_code_of(value)
    value.gsub(/\./, "").strip
  end
  
  # Returns the value as pretty code if it is available in the db.
  # Throws a Runtime Error if the given value is not valid.
  def self.pretty_code_of(value)
    db_entry = self.find_by_OpShort(short_code_of(value))
    raise "'#{value}' is not a valid icd code" if db_entry.nil?
    db_entry.OpCode
  end
end
