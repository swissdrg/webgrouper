class Query
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :valid_case, type: Boolean
  field :time, type: Time

  index :time => 1
end