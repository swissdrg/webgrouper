class Query
  include Mongoid::Document
  field :age, type: Integer
  field :age_days, type: Integer
  field :age_years, type: Integer
  field :hmv, type: Integer
  field :adm_weight, type: Integer
  field :system_id, type: Integer
  
end