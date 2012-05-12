class Supplement < ActiveRecord::Base
	has_many :OPS, :through => :supplement_ops, :foreign_key => "fee"
	has_many :supplement_ops	
	
	default_scope lambda{where(:system => System.current_system_id)}

	def self.table_name
		'supplement'	
	end
end
