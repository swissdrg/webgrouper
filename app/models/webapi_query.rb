# For logging queries to the webapi
class WebapiQuery
  include Mongoid::Document

  field :ip, type: String
  field :system_id, type: Integer
  field :output_format, type: String
  field :user_agent, type: String
  field :start_time, type: DateTime
  field :finished_parsing_time, type: DateTime
  field :end_time, type: DateTime
  field :nr_cases, type: Integer
  field :error, type: String
end