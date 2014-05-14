class Supplement
  include Mongoid::Document
  field :chop_atc_code, type: String
  field :supplement_code, type: String
  field :amount, type: Float
  field :version, type: String
  field :text, type: String, localize: true

  # These are not used actually, but available in the database for V4.0 and up
  field :route_of_administration, type: String
  field :age_max, type: Integer

  field :dose_min, type: Float
  field :dose_max, type: Float
  field :dose_unit, type: String

  scope :in_system, lambda { |system_id| where(:version => System.find_by(:system_id => system_id ).drg_version) }

  index :chop_code => 1, :version => 1
end
