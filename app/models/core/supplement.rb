class Supplement
  include Mongoid::Document
  self.collection_name = "chop"
  
	#TODO: scope
	scope :in_system, lambda { |system_id| where(:chop_version => System.where(:system_id => system_id ).first.chop_version) }

end
