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
  Scenario: testfile with "SwissDRG 2.0 Planungsversion 1"
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten.csv"
  	And I select in "batchgrouper_system_id" "SwissDRG 2.0 Planungsversion 1"
  	And I press on "Gruppieren"
  	Then I should receive a file called "testdaten.csv.out"
  	And the MD5sum of it should be "858fbfdc4014b262816ae4ef6e01ad6d"

  @rack_test
  Scenario: testfile with "SwissDRG 2.0 Planungsversion 2"
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten.csv"
  	And I select in "batchgrouper_system_id" "SwissDRG 2.0 Planungsversion 2"
  	And I press on "Gruppieren"
  	Then I should receive a file called "testdaten.csv.out"
  	And the MD5sum of it should be "e1ac57a7c0bb6059f2604aa2626b20ad"

  @rack_test
  Scenario: testfile grouped as "Geburtshaus"
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten.csv"
  	And I select in "batchgrouper_system_id" "SwissDRG 2.0 Katalogversion"
  	And I select in "batchgrouper_house" "Geburtshaus"
  	And I press on "Gruppieren"
  	Then I should receive a file called "testdaten.csv.out"
  	And the MD5sum of it should be "3e9722303f459904fd390cafcde0cb28"

  @rack_test
  Scenario: testfile with system SwissDRG 2.0 Katalogversion
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten.csv"
  	And I select in "batchgrouper_system_id" "SwissDRG 2.0 Katalogversion"
  	And I press on "Gruppieren"
  	Then I should receive a file called "testdaten.csv.out"
  	And the MD5sum of it should be "20f5d435618204ec4c282fc5d307fc7f"
