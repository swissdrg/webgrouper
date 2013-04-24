Feature: Batchgroupings page under test
  Any user  

  @rack_test
  Scenario: testfile with standard system
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten.csv"
  	And I press on "Gruppieren"
  	Then I should receive a file called "testdaten.csv.out"
  	And the MD5sum of it should be "baea95d38f9871749eefaa6714499824"

  @rack_test
  Scenario: testfile with umlaut in name should succeed
    Given the batchgrouper with initialized standard values
    When I attach a file called "ümläüté.csv"
    And I press on "Gruppieren"
    Then I should receive a file called "ümläüté.csv.out"
    And the MD5sum of it should be "baea95d38f9871749eefaa6714499824"

  @rack_test
  Scenario: testfile with "SwissDRG 2.0 Planungsversion 1"
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten.csv"
  	And I select system 11
  	And I press on "Gruppieren"
  	Then I should receive a file called "testdaten.csv.out"
  	And the MD5sum of it should be "61336ed399cfe9994ca10a274ecf18a1"

  @rack_test
  Scenario: testfile with "SwissDRG 2.0 Planungsversion 2"
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten.csv"
    And I select system 12
  	And I press on "Gruppieren"
  	Then I should receive a file called "testdaten.csv.out"
  	And the MD5sum of it should be "11b4f50adda87785714d9178b71ee6e5"

  @rack_test
  Scenario: testfile grouped as "Geburtshaus"
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten.csv"
    And I select system 10
  	And I select in "batchgrouper_house" "Geburtshaus"
  	And I press on "Gruppieren"
  	Then I should receive a file called "testdaten.csv.out"
  	And the MD5sum of it should be "410cf372e2cf5d9088a13aca35920d9a"

  @rack_test
  Scenario: testfile with system SwissDRG 2.0 Katalogversion
  	Given the batchgrouper with initialized standard values
  	When I attach a file called "testdaten.csv"
    And I select system 10
  	And I press on "Gruppieren"
  	Then I should receive a file called "testdaten.csv.out"
  	And the MD5sum of it should be "145ab9c219c4a2d9a0a738e4ea31320b"
  	
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
  	
