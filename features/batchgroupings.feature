Feature: Batchgroupings page under test
  Any user  

  @rack_test
  Scenario: testfile should have same values like in old grouper
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten.csv"
  	And I press on "Gruppieren"
  	Then I should receive a file called "testdaten.csv.out"
  	And the MD5sum of it should be "978eadd0a572d47014a4d14ed1cfacf0"
