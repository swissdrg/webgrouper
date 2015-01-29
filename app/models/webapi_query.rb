# For logging queries to the webapi
class WebapiQuery
  include Mongoid::Document

  field :ip, type: String
  field :system_id, type: Integer
  field :input_format, type: String
  field :output_format, type: String
  field :user_agent, type: String
  field :start_time, type: Time
  field :finished_parsing_time, type: Time
  field :end_time, type: Time
  field :nr_cases, type: Integer
  field :error, type: String

  index :start_time => 1
end