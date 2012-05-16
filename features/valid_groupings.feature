Feature: Grouping a valid patient case should return right results
  A normal user
  Should group without any conflicts and validation errors, when entering a valid case
  
  Scenario: A random valid patient case
    Given the form with initialized standard values

    When I enter some random (valid!) data
    And I press on "Fall Gruppieren"

    Then the grouping should succeed
    And the form should stay the same
    And the result should be shown
    
    
  Scenario: Standard form with only diagnosis
    Given the form with initialized standard values

    When I enter "S39.80" as diagnosis
    And I press on "Fall Gruppieren"

    And the grouping should succeed
    And I should see "21B" in "grouping"
    And I should see "X60Z" in "grouping"
    And I should see "0" in "grouping"
    And I should see "0.576" in "cost-weight"
    And I should see "0.576" in "cost-weight"

  Scenario: Standard form with diagnosis (as short code) and a overlier los
    Given the form with initialized standard values

    When I enter "S3980" as diagnosis
    And I enter "40" as los
    And I press on "Fall Gruppieren"

    Then the grouping should succeed
    And I should see "21B" in "grouping"
    And I should see "X60Z" in "grouping"
    And I should see "0" in "grouping"
    And I should see "0.576" in "cost-weight"
    And I should see "3.276" in "cost-weight"
    And I should see "30" in "cost-weight"
    And I should see "0.09" in "cost-weight"
    And I should see "Penisfraktur" in "diagnoses"
    And I should see "S39.80" in "diagnoses"
    
  @javascript
  Scenario: Autocomplete should find right things
  	Given the form with initialized standard values
  	
  	When I enter "rand" as diagnosis
  	And I choose "Hautmilzbrand" in the autocomplete list
  	And I submit the form
  	
  	Then the grouping should succeed
  	And I should see "A22.0" in "diagnoses"
  	
  @javascript @critical
  Scenario: Changing age should have an effect
  	Given the form with initialized standard values
  	
  	When I enter "Q18.1" as diagnosis
    And I enter "5" as los
    And I press on "Fall Gruppieren"
    Then I should see "D66Z" in "grouping"
    
    When I enter "1" as age
    And I select "days" as age mode
    And I enter "3620" as admission weight
    And I press on "Fall Gruppieren"
    Then I should see "P67D" in "grouping"
    
    When I enter "2222" as admission weight
    And I submit the form
    Then I should see "P66D" in "grouping"
    
    When I enter "1100" as admission weight
    And I submit the form
    Then I should see "P63Z" in "grouping"
    
    When I enter "700" as admission weight
    And I submit the form
    Then I should see "P61D" in "grouping"
    