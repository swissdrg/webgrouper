require 'rails_helper'

RSpec.describe 'The webapi handles multiple queries in parallel', type: :feature do
  pc_strings = ["1;0;27;;W;11;00;48;;;P072;;;;P071;;P920;;R068;;R001;;P612;;H351;;P742;;A048;;P928;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;966;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;",
                "2;40;0;4000;U;99;99;10;;0;S390;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;",
                "3;40;0;4000;U;99;99;10;;0;A078;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;0052::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
  ]

  specify "three parallel groupings with same system" do
    parsed_results = {}
    threads = pc_strings.map do |string|
      Thread.new(string) do |pc|
        all_pcs = ""
        100.times do
          all_pcs << pc + "\n"
        end
        params = {:format => 'json', :input_format => 'swissdrg', :pc => all_pcs}
        result, duration = group_as_json(params, ENV_API)
        assert_equal(100, result.size, "Failed with #{result}")
        parsed_results[string[0]] = result
      end
    end

    threads.each { |aThread|  aThread.join }
    parsed_results["1"].each do |r|
      assert_equal "1", r["PatientCase"]["id"]
      assert_equal "P67B", r["GrouperResult"]["drg"]
      assert_equal 40330, r["EffectiveCostWeight"]["effectiveCostWeight"]
      assert_equal 9, r["SystemId"]
    end

    parsed_results["2"].each do |r|
      assert_equal "2", r["PatientCase"]["id"]
      assert_equal "I68D", r["GrouperResult"]["drg"]
      assert_equal 5530, r["EffectiveCostWeight"]["effectiveCostWeight"]
      assert_equal 9, r["SystemId"]
    end

    parsed_results["3"].each do |r|
      assert_equal "3", r["PatientCase"]["id"]
      assert_equal "901D", r["GrouperResult"]["drg"]
      assert_equal 17490, r["EffectiveCostWeight"]["effectiveCostWeight"]
      assert_equal 9, r["SystemId"]
    end
  end

  specify "three parallel groupings with different systems" do
    systems = ["9", "10", "12"]
    threads = []
    parsed_results = {}
    pc_strings.zip(systems).each do |string, system|
      threads << Thread.new(string) do |pc|
        all_pcs = ""
        (1..100).each do
          all_pcs += pc + "\n"
        end
        params = {:format => 'json', :input_format => 'swissdrg', :pc => all_pcs, :system => system}
        result, duration = group_as_json(params, ENV_API)
        assert_equal(100, result.size, "Failed with #{result}")
        parsed_results[string[0]] = result
      end
    end

    threads.each { |aThread|  aThread.join }
    parsed_results["1"].each do |r|
      assert_equal "1", r["PatientCase"]["id"]
      assert_equal "P67B", r["GrouperResult"]["drg"]
      assert_equal 40330, r["EffectiveCostWeight"]["effectiveCostWeight"]
      assert_equal "9", r["SystemId"]
    end

    parsed_results["2"].each do |r|
      assert_equal "2", r["PatientCase"]["id"]
      assert_equal "I68D", r["GrouperResult"]["drg"]
      assert_equal 5520, r["EffectiveCostWeight"]["effectiveCostWeight"]
      assert_equal "10", r["SystemId"]
    end

    parsed_results["3"].each do |r|
      assert_equal "3", r["PatientCase"]["id"]
      assert_equal "901D", r["GrouperResult"]["drg"]
      assert_equal 17490, r["EffectiveCostWeight"]["effectiveCostWeight"]
      assert_equal "12", r["SystemId"]
    end
  end
end