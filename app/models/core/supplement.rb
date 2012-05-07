class Supplement < ActiveRecord::Base
	has_many :OPS, :through => :supplement_ops, :foreign_key => "fee"
	has_many :supplement_ops	

	def self.table_name
		'supplement'	
	end
end
