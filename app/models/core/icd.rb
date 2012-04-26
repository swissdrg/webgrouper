class ICD < ActiveRecord::Base

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
  
  #Returns the value as pretty code if it is available in the db or
  #the value itself unchanged if it is not part of the db.
  #Returns nil if there is no entry in the database for given the value.
  def self.pretty_code_of(value)
    db_entry = self.find_by_IcShort(short_code_of(value))
    db_entry ? db_entry.IcCode : nil
  end
end