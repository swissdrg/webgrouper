class DRGName < ActiveRecord::Base
	belongs_to :DRG
	def self.table_name
    "drgname"
  end
end
