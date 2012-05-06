class ICD < ActiveRecord::Base
	has_many :names, :class_name => "ICDName", :foreign_key => "InFkIcID" 
  default_scope lambda{where(:IcFKSyID => System.current_system.SyID)}

  def self.table_name
    "icd"
  end

  def autocomplete_result
    "#{self.IcCode} #{self.IcName}"
  end
  
  def self.short_code_of(value)
    value.gsub(/\./, "").strip
  end
  
  # Returns the value as pretty code if it is available in the db.
  # Throws a Runtime Error if the given value is not valid.
  def self.pretty_code_of(value)
    db_entry = self.find_by_IcShort(short_code_of(value))
    raise "'#{value}' is not a valid icd code" if db_entry.nil?
    db_entry.IcCode
  end
end
