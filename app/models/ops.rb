class OPS < ActiveRecord::Base

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
  
  #Returns the value as pretty code if it is available in the db or
  #the value itself unchanged if it is not part of the db.
  #TODO: dont swallow the the error
  def self.pretty_code_of(value)
    db_entry = self.find_by_OpShort(short_code_of(value))
    if db_entry.nil?
      value
    else
      db_entry.OpCode
    end
  end
end
