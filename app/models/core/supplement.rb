class Supplement
  include Mongoid::Document
  field :chop_code, type: String
  field :supplement_code, type: String
  field :version, type: String

  scope :in_system, lambda { |system_id| where(:version => System.where(:system_id => system_id ).first.drg_version) }

  index :chop_code => 1, :version => 1
end
