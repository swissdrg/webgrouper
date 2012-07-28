# encoding: UTF-8

require 'test_helper'
require 'rails/performance_test_help'

class ViewGroupingTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory]
  #                          :output => 'tmp/performance', :formats => [:flat] }

  def test_empty_form
    get "/"
  end

end
