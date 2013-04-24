Feature: Batchgroupings page under test
  Any user  

  @rack_test
  Scenario: testfile with standard system
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten.csv"
  	And I press on "Gruppieren"
  	Then I should receive a file called "testdaten.csv.out"
  	And the MD5sum of it should be "978eadd0a572d47014a4d14ed1cfacf0"

  @rack_test
  Scenario: testfile with umlaut in name should succeed
    Given the batchgrouper with initialized standard values
    When I attach a file called "ümläüté.csv"
    And I press on "Gruppieren"
    Then I should receive a file called "ümläüté.csv.out"
    And the MD5sum of it should be "978eadd0a572d47014a4d14ed1cfacf0"

  @rack_test
  Scenario: testfile with "SwissDRG 2.0 Planungsversion 1"
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten.csv"
  	And I select system 11
  	And I press on "Gruppieren"
  	Then I should receive a file called "testdaten.csv.out"
  	And the MD5sum of it should be "858fbfdc4014b262816ae4ef6e01ad6d"

  @rack_test
  Scenario: testfile with "SwissDRG 2.0 Planungsversion 2"
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten.csv"
    And I select system 12
  	And I press on "Gruppieren"
  	Then I should receive a file called "testdaten.csv.out"
  	And the MD5sum of it should be "e1ac57a7c0bb6059f2604aa2626b20ad"

  @rack_test
  Scenario: testfile grouped as "Geburtshaus"
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten.csv"
    And I select system 10
  	And I select in "batchgrouper_house" "Geburtshaus"
  	And I press on "Gruppieren"
  	Then I should receive a file called "testdaten.csv.out"
  	And the MD5sum of it should be "3e9722303f459904fd390cafcde0cb28"

  @rack_test
  Scenario: testfile with system SwissDRG 2.0 Katalogversion
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten.csv"
    And I select system 10
  	And I press on "Gruppieren"
  	Then I should receive a file called "testdaten.csv.out"
  	And the MD5sum of it should be "20f5d435618204ec4c282fc5d307fc7f"
  	
  Scenario: Single group a valid case without any special characters
  	Given the batchgrouper with initialized standard values
  	When I fill in "batchgrouper_single_group" with "583109;0;1;3540;M;01;00;6;;0;P221;;;;P201;;P081;;Z380;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;897::20110719;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
  	And I press on "Gruppieren"
  	And I wait 1 seconds
  	Then I should see "583109;P67D;15;1;0;00;0;2040;01"

  Scenario: Single group a case without enough columns
  	Given the batchgrouper with initialized standard values
  	When I fill in "batchgrouper_single_group" with "583109;0;1;3540;M;01;00;6;;0;P221;;;;P201;;P081;;Z380;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;897::20110719;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;"
  	And I press on "Gruppieren"
  	Then I should see "Invalides Format"
  	
  Scenario: Single group complete nonsense
  	Given the batchgrouper with initialized standard values
  	When I fill in "batchgrouper_single_group" with "Zomfg group my stuff plxplx"
  	And I press on "Gruppieren"
  	Then I should see "Invalides Format"
  	
  Scenario: BFS Format should be detected and give an error
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten_pipe.csv"
  	And I press on "Gruppieren"
  	Then I should see "BFS Format erkannt. Bitte groupieren sie Dateien nur im SwissDRG Format."
  	
