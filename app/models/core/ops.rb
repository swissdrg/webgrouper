class OPS < ActiveRecord::Base
	has_many :names, :class_name => "OPSName", :foreign_key => "OnFkOpID" 
  default_scope lambda{where(:OpFkSyID => System.current_system.SyID)}

  def self.table_name
    "ops"
  end

  def autocomplete_result
    "#{self.OpCode} #{self.OpName}"
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
