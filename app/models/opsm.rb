class Opsm < ActiveRecord::Base
  default_scope lambda{where(:OpFkSyID => System.current_system_id)}
  
  def self.table_name
    'opsm'
  end
  
  def OpName
    system_language = I18n.locale.to_s.upcase
		description = self.send("lang#{system_language}")
		description ||= self.langDE
	end
  
  def autocomplete_result
    "#{self.OpCode} #{self.OpName}"
  end
end
