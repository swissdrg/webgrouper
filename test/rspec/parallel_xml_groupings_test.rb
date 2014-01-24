require "uri"
require "net/http"
require 'benchmark'
require './test/rspec/rspec_helper'

describe 'Some parallel XML groupings' do
  specify "Only one very large xml input" do
    xml_input = File.open(File.join('test', 'even_larger_xml_input.xml')).read()
    params = {:format => 'json', :input_format => 'xml', :pc => xml_input, :system => '15'}
    result, duration = group_as_json(params, ENV_API)
    puts("Received results, took #{duration} seconds ")
    assert_equal(765, result.size, "Failed with #{result}")

    result.each do |r|
      #assert_equal "1", r["PatientCase"]["id"]
      #assert_equal "P67B", r["GrouperResult"]["drg"]
      #assert_equal 40330, r["EffectiveCostWeight"]["effectiveCostWeight"]
      assert_equal "15", r["SystemId"]
    end
  end

  specify "three parallel huge xml on different systems" do
    xml_input = File.open(File.join('test', 'huge_xml_input.xml')).read()
    systems = ["9", "10", "12"]
    threads = []
    parsed_results = {}
    puts "Trying with huge xml input on different systems"
    (0..2).each do |idx|
      threads << Thread.new(systems[idx], xml_input) do |system, pc|
        puts("Sending post for system #{system}")
        params = {:format => 'json', :input_format => 'xml', :pc => pc, :system => system}
        result, duration = group_as_json(params, ENV_API)
        puts("Received results for system #{system}, took #{duration} seconds ")
        assert_equal(255, result.size, "Failed with #{result}")
        parsed_results[system] = result
      end
    end

    #wait until all requests finished
    threads.each { |t|  t.join }

    parsed_results["9"].each do |r|
      #assert_equal "1", r["PatientCase"]["id"]
      #assert_equal "P67B", r["GrouperResult"]["drg"]
      #assert_equal 40330, r["EffectiveCostWeight"]["effectiveCostWeight"]
      assert_equal 9, r["SystemId"]
    end

    parsed_results["10"].each do |r|
      #assert_equal "2", r["PatientCase"]["id"]
      #assert_equal "I68D", r["GrouperResult"]["drg"]
      #assert_equal 5520, r["EffectiveCostWeight"]["effectiveCostWeight"]
      assert_equal 10, r["SystemId"]
    end

    parsed_results["12"].each do |r|
      #assert_equal "3", r["PatientCase"]["id"]
      #assert_equal "901D", r["GrouperResult"]["drg"]
      #assert_equal 17490, r["EffectiveCostWeight"]["effectiveCostWeight"]
      assert_equal 12, r["SystemId"]
    end
  end

  specify "three parallel even larger xml inputs on different systems" do
    xml_input = File.open(File.join('test', 'even_larger_xml_input.xml')).read()
    systems = ["9", "10", "12"]
    threads = []
    parsed_results = {}
    puts "Trying with even lrager xml input on different systems"
    (0..2).each do |idx|
      threads << Thread.new(systems[idx], xml_input) do |system, pc|
        puts("Sending post for system #{system}")
        params = {:format => 'json', :input_format => 'xml', :pc => pc, :system => system}
        result, duration = group_as_json(params, ENV_API)
        puts("Received results for system #{system}, took #{duration} seconds ")
        assert_equal(765, result.size, "Failed with #{result}")
        parsed_results[system] = result
      end
    end

    #wait until all requests finished
    threads.each { |t|  t.join }

    parsed_results["9"].each do |r|
      #assert_equal "1", r["PatientCase"]["id"]
      #assert_equal "P67B", r["GrouperResult"]["drg"]
      #assert_equal 40330, r["EffectiveCostWeight"]["effectiveCostWeight"]
      assert_equal 9, r["SystemId"]
    end

    parsed_results["10"].each do |r|
      #assert_equal "2", r["PatientCase"]["id"]
      #assert_equal "I68D", r["GrouperResult"]["drg"]
      #assert_equal 5520, r["EffectiveCostWeight"]["effectiveCostWeight"]
      assert_equal 10, r["SystemId"]
    end

    parsed_results["12"].each do |r|
      #assert_equal "3", r["PatientCase"]["id"]
      #assert_equal "901D", r["GrouperResult"]["drg"]
      #assert_equal 17490, r["EffectiveCostWeight"]["effectiveCostWeight"]
      assert_equal 12, r["SystemId"]
    end
  end
end

