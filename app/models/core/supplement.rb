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
  field :age_min, type: Integer

  field :dose_min, type: Float
  field :dose_max, type: Float
  field :dose_unit, type: String
  field :constraint_icds, type: Array
  field :excluded_drgs, type: Array

  belongs_to :system, primary_key: :drg_version, foreign_key: :version

  # This is strangely enough not unique.
  index({:chop_code => 1, :version => 1})
end
