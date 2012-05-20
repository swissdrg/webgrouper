class ICDM < ActiveRecord::Base
  default_scope lambda{where(:IcFKSyID => System.current_system_id)}
  
  def self.table_name
    'icdm'
  end
  
  def IcName
    system_language = I18n.locale.to_s.upcase
		description = self.send("lang#{system_language}")
		description ||= self.langDE
	end
  
  def autocomplete_result
    "#{self.IcCode} #{self.IcName}"
  end
end