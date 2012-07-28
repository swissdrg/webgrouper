# encoding: UTF-8

require 'test_helper'
require 'rails/performance_test_help'

class QueryTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory]
  #                          :output => 'tmp/performance', :formats => [:flat] }

  def test_only_query
    Drg.find_by_code(9, "I08C")
  end
  
  def test_multiple_query_same_code
    Drg.find_by_code(9, "I08C")
    Drg.get_description_for(9, "I08C")
    Drg.reuptake_exception?(9, "I08C")
  end

end