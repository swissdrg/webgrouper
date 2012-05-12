class SupplementOps < ActiveRecord::Base
	
	default_scope lambda{where(:system => System.current_system_id)}
	
	def self.table_name
		'supplement_ops'	
	end
end
