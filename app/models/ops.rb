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
  
  def self.pretty_code_of(value)
    self.find_by_OpShort(short_code_of(value)).OpCode
  end
end
