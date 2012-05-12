class DRG < ActiveRecord::Base
	has_many :names, :class_name => "DRGName", :foreign_key => "DnFkDrID" 
  default_scope lambda{where(:DrFKSyID => System.current_system.SyID)}
	
	def DrName
		system_language = I18n.locale.to_s.upcase
		description = self.names.select{|name| name.DnLang == system_language}.first
		description ||= self.names.select{|name| name.DnLang == "DE"}.first
		description.DnName
	end  

  def self.table_name
    "drg"
  end

	def self.reuptake_exception_for?(dr_code)
		drg = DRG.find_by_DrCode dr_code
		drg.exception_from_reuptake
	end

end
