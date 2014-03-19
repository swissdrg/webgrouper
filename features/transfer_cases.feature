Feature: Any transfer case should be handled correctly
  Any user
  
  Scenario: Float precision shouldn't make troubles anymore
  	Given the form with initialized standard values
  	When I enter "I26.9" as diagnosis
  	And I enter "1" as los
  	And I submit the form
  	Then I should see "3" in "cost-weight"
  	And I should see "0.305" in "cost-weight"
  	When I enter Transfered (los more than 24 hours) as admission mode
  	And I submit the form
  	Then I should see "Verlegungsabschlagspflichtig" in "length-of-stay"
  	And I should see "0.2015" in "cost-weight"
  	And I should see "10.5" in "cost-weight"
  	
  Scenario: Strahlenzystis mit los 3 und Transfer
    Given the form with initialized standard values

    When I enter "N30.4" as diagnosis
    And I enter "3" as los
    And I enter Transfered (los more than 24 hours) as admission mode
    And I press on "Fall Gruppieren"

    Then the grouping should succeed
    And I should see "11" in "grouping"
    And I should see "L62B" in "grouping"
    And I should see "Normale Gruppierung" in "grouping"
    And I should see "0.68" in "cost-weight"
    And I should see "0.4616" in "cost-weight"
    And I should see "Strahlenzystitis" in "result-diagnoses"
    And I should see "N30.4" in "result-diagnoses"
    And I should see "Verlegungsabschlagspflichtig" in "length-of-stay"