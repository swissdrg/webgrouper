Feature: The edge cases should be handled correctly
  Any user
  
  Scenario: Case for reuptake
  	Given the form with initialized standard values
  	When I enter "Q28.81" as diagnosis
  	And I enter "30" as hmv
  	And I submit the form
  	Then I should see "Die DRG F43C ist von einer Fallzusammenführung bei Wiederaufnahme ausgeschlossen." in "settlement_hints"
  
  @javascript
  Scenario: Case for additional fee
  	Given the form with initialized standard values
  	When I enter "B72" as diagnosis
  	And I enter "39.95.21" as procedure
  	And I submit the form
  	Then I should see "Hämodialyse, Hämodiafiltration, Hämofiltration, intermittierend" in "settlement_hints"
  	And I should see "ZE01-2012" in "settlement_hints"
  	And I should see "39.95.21" in "settlement_hints"
  
# TESTS FOR RIGHT DRG
  # groupertest.java L67
  @javascript
  Scenario: parse case pdx P67D
	  Given the form with initialized standard values
	  When I parse "38853;0;1;3620;W;01;01;5;;;Q181;;;;P153;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;897;;;;;;;;;;;;;;;;;;;;;" as input for the form
	  Then I should see "P67D" in "grouping"
	  
	
  # groupertest.java L 74
  @javascript
  Scenario: parse case pdx F03Z, should be inlier
	  Given the form with initialized standard values
	  When I select "Katalogversion 0.3 2008/2011" as system
	  And I parse "44364;55;;;W;01;01;15;;;I080;;;;E039;;I10;;I48;;I270;;I501;;F171;;E669;;E785;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;3964;3961;9671;9390;8872;3995;3962;3512;3734;3533;3963;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" as input for the form
	  Then I should see "F03Z" in "grouping"
	  And I should see "Normallieger" in "length-of-stay"

  # groupertest.java L 81
  @javascript
  Scenario: parse case pdx H63C (low CC) and H63B (high CC)
    Given the form with initialized standard values
    When I parse "53567;10;;;U;01;01;50;0;0;B58.1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" as input for the form
    Then I should see "H63C" in "grouping"
    When I enter the secondary diagnoses "C83.7", "E24.1"
    And I submit the form
    Then I should see "H63B" in "grouping"
	  
# groupertest.java L 88
# Changed to valid diagnosis codes
# 9359 is an invalid procedure, so removed it
# & sanitized some diag codes
# had to change expectations due to this
  @javascript
  Scenario: parse with different dates
    Given the form with initialized standard values
    When I parse "53567;68;;;W;01;01;5;;;S068;;;;S4220;;S4240;;S066;;S065;;S501;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" as input for the form
    Then I should see "B78A" in "grouping"
	And I should see "5" in "length-of-stay"
	
    When I fill in "webgrouper_patient_case_entry_date" with "01.02.2008"
    And I fill in "webgrouper_patient_case_exit_date" with "10.02.2008"
    And I fill in "webgrouper_patient_case_birth_date" with "02.01.2003"
    And I wait 1 seconds
    And I submit the form
    Then I should see "B78A" in "grouping"
    And I should see "9" in "length-of-stay"  
    When I fill in "webgrouper_patient_case_exit_date" with "01.02.2008"
    And I wait 1 seconds
    And I submit the form
    Then I should see "1" in "length-of-stay"
    Then I should see "B78C" in "grouping"
    
  # groupertest.java L 125
  @javascript
  Scenario: parse with different systems
	Given the form with initialized standard values
	When I select system 5
	And I parse "56;10;0;;2;01;00;3;0;;S424;" as input for the form
	And I enter the procedures with seitigkeit and date "7911::20080307"
    Then I should see "Hauptdiagnose: invalid"
	  
    When  I select system 4
	And I submit the form
	Then the grouping should succeed
    Then I should see "I13B" in "grouping"
   
# TESTS FOR DATE EXCEPTIONS/LEAP YEARS
# calcCostWeightTest.java L10
  @javascript
  Scenario: calculate length of stay for normal year
    Given the form with initialized standard values
    When I parse "53567;10;;;U;01;01;50;0;0;B58.1;C83.7;E24.1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" as input for the form
    And I fill in "webgrouper_patient_case_entry_date" with "26.02.2010"
    And I fill in "webgrouper_patient_case_exit_date" with "01.03.2010"
    And I wait 1 seconds
    And I submit the form
    Then I should see "3" in "length-of-stay"

  # calcCostWeightTest.java L10
  @javascript
  Scenario: calculate length of stay for leap year
    Given the form with initialized standard values
    When I parse "53567;10;;;U;01;01;50;0;0;B58.1;C83.7;E24.1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" as input for the form
    And I fill in "webgrouper_patient_case_entry_date" with "26.02.2012"
    And I fill in "webgrouper_patient_case_exit_date" with "01.03.2012"
    And I wait 1 seconds
    And I submit the form
    Then I should see "4" in "length-of-stay"
    
#TESTS FOR MEDICAL FLAGS

  # calcCostWeightTest.java L10
  @javascript
  Scenario: calculate length of stay for leap year
    Given the form with initialized standard values
    When I parse "53567;15;;;M;01;01;10;;;R509;BLAA;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" as input for the form
    Then I should see "Nebendiagnosen: BLAA invalid"



# TESTS FOR LENGTH OF STAY
  # calcCostWeightTest.java L10
  @javascript
  Scenario: Case for transfer patient
    Given the form with initialized standard values
    When I parse "12;28;;;U;99;06;2;0;0;J632;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" as input for the form
    Then I should see "E74Z" in "grouping"
    And I should see "0.371" in "cost-weight"
  	And I should see "Verlegungsabschlagspflichtig" in "length-of-stay"
  	
  # calcCostWeightTest.java L15
  @javascript
  Scenario: Case for lower outlier
    Given the form with initialized standard values
    When I parse "12;28;;;U;99;00;2;0;0;J632;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" as input for the form
    Then I should see "E74Z" in "grouping"
    And I should see "0.811" in "cost-weight"
  	And I should see "Unterer Outlier" in "length-of-stay"
  	And I should see "Berylliose" in "diagnoses"
  	

  # calcCostWeightTest.java L21
  @javascript
  Scenario: Case for inlier
    Given the form with initialized standard values
    When I parse "12;28;;;U;99;00;22;0;0;J632;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" as input for the form
    Then I should see "E74Z" in "grouping"
    And I should see "1.181" in "cost-weight"
  	And I should see "Normallieger" in "length-of-stay"

  # calcCostWeightTest.java L27
  @javascript
  Scenario: Case for upper outlier
    Given the form with initialized standard values
    When I parse "12;28;;;U;99;00;23;0;0;J632;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" as input for the form
    Then I should see "E74Z" in "grouping"
    And I should see "1.258" in "cost-weight"
  	And I should see "Oberer Outlier" in "length-of-stay"
  	
  # calcCostWeightTest.java L33
  @javascript
  Scenario: Case for unweighted DRG
    Given the form with initialized standard values
    When I parse "12;28;;;U;99;00;22;0;0;Z85.6;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" as input for the form
    Then I should see "961Z" in "grouping"
  	And I should see "Unbewertete DRG" in "length-of-stay"
  	
  	
  # calcCostWeightTest.java L39
  @javascript
  Scenario: Case for upper outlier
    Given the form with initialized standard values
    When I parse "12;28;;;U;99;00;9999;0;0;J632;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" as input for the form
    Then I should see "E74Z" in "grouping"
    And I should see "769.41" in "cost-weight"
  	And I should see "Oberer Outlier" in "length-of-stay"
  	
  @javascript
  Scenario: Test case for B78C
  	Given the form with initialized standard values
  	When I enter "S06.1" as diagnosis
  	And I enter "1" as los
  	And I submit the form
  	Then I should see "B78C" in "grouping"
  	