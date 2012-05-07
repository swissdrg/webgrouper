class SupplementOps < ActiveRecord::Base
	belongs_to :OPS, :primary_key => "OpCode"
	belongs_to :supplement, :primary_key => "fee"
	
	def self.table_name
		'supplement_ops'	
	end
end
