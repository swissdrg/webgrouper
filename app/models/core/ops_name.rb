class OPSName < ActiveRecord::Base
	belongs_to :OPS
	def self.table_name
    "opsname"
  end
end
