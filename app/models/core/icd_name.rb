class ICDName < ActiveRecord::Base
	belongs_to :ICD
	def self.table_name
    "icdname"
  end
end
