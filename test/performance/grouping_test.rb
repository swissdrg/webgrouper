require 'test_helper'
require 'rails/performance_test_help'

class GroupingTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory]
  #                          :output => 'tmp/performance', :formats => [:flat] }

    # called before every single test
  def setup
    @pc = WebgrouperPatientCase.new({:pdx => "S39.0"})
  end
  
  def test_empty_case
    WebgrouperPatientCase.new
  end
  
  def test_creating_case
    WebgrouperPatientCase.new({:pdx => "S39.0"})
  end
  
  def test_validation_of_case
    assert @pc.valid?
  end
  
  def test_load_grouper
    GROUPER.load(spec_path(9))
  end
  
  def test_grouping
    GROUPER.group(@pc)
  end
  
  def test_creating_weighting_relation
    # @weighting_relation = WebgrouperWeightingRelation.new(Drg.find_by_code(@pc.system_id, @result.drg))
  end
end
