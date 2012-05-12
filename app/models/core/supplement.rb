class Supplement < ActiveRecord::Base
	
	default_scope lambda{where(:system => System.current_system_id)}

	def self.table_name
		'supplement'	
	end
end
