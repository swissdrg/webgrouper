class Supplement
  include Mongoid::Document
  field :chop_atc_code, type: String
  field :supplement_code, type: String
  field :amount, type: Float
  field :version, type: String
  field :route_of_administration, type: String
  field :text, type: String, localize: true

  scope :in_system, lambda { |system_id| where(:version => System.where(:system_id => system_id ).first.drg_version) }

  index :chop_code => 1, :version => 1
end
