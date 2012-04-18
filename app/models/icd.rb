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
  
  #TODO: don't throw an exception into my face if short code isn't found
  def self.pretty_code_of(value)
    self.find_by_IcShort(short_code_of(value)).IcCode
  end
end