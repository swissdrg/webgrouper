class Supplement
  include Mongoid::Document
  self.collection_name = "chop"
  
	#TODO: scope
	default_scope lambda{where(:chop_version => System.current_system.chop_version)}

end
