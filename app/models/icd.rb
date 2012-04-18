class ICD < ActiveRecord::Base

  scope :active_system, lambda{where(:IcFKSyID => 9)}

  def self.table_name
    "icd"
  end

  def autocomplete_result
    "#{self.IcCode} #{self.IcName}"
  end
end