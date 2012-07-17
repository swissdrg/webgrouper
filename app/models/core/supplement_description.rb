class SupplementDescription
  include Mongoid::Document
  
  scope :in_system, lambda { |system_id| where(:version => System.where(:system_id => system_id ).first.drg_version) }

end