class BatchgrouperQuery
  include Mongoid::Document
  
  field :ip, type: String
  field :first_line, type: String
  field :line_count, type: Integer
end