Feature: Users can add and remove fields for secondary diagnoses and procedures dynamically
  In order to group as many diagnoses and procedures as possible
  As a normal user
  I want to be able to generate input fields for secondary diagnoses and procedures and remove them again
  
  @mac @javascript
  Scenario: I can add secondary diagnoses fields
    Given the form with initialized standard values
    When I follow "add_diagnoses"
    Then I should see 10 diagnoses fields
    
  @mac @javascript
  Scenario: I can add procedures fields
  Given the form with initialized standard values
  When I follow "add_procedures"
  Then I should see 6 procedures fields
  
  @mac @javascript
  Scenario: I can add less than 100 diagnoses fields in total
    Given the form with initialized standard values
    When I add the maximum number of "diagnoses" fields
    And I should not see 100 diagnoses fields
  
  @mac @javascript
  Scenario: I can add less than 101 procedures fields in total
    Given the form with initialized standard values
    When I add the maximum number of "procedures" fields
    And I should not see 101 procedures fields
  
    @mac @javascript
    Scenario: I can enter up to 94 diagnoses
      Given the form with initialized standard values
      When I enter "A000" as diagnosis
      And I enter the secondary diagnoses "A000" 95 times
      And I press on "Fall Gruppieren"
      Then the grouping should succeed
      
  @debug @mac @javascript
  Scenario: I can enter up to 99 procedures
    Given the form with initialized standard values
    When I enter "A000" as diagnosis
    And I enter the procedures "00.01" 99 times
    And I press on "Fall Gruppieren"
    Then the grouping should succeed
    
