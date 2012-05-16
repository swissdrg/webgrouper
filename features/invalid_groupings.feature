Feature: Grouping a valid patient case should return right results
  A normal user who speaks german
  Should see validation errors, when entering an invalid case
  
  @mac
  Scenario: Submit the form without a primary diagnosis
    Given the form with initialized standard values
    When I press on "Fall Gruppieren"
    Then I should see "Hauptdiagnose: muss ausgefüllt werden"
    
  @mac
  Scenario: Submit the form with invalid primary diagnosis
    Given the form with initialized standard values
    When I enter "foo" as diagnosis
    And I press on "Fall Gruppieren"
    Then I should see "Hauptdiagnose: invalid"
    
  @mac @javascript
  Scenario: Submit the form with invalid secondary diagnosis
    Given the form with initialized standard values
    When I enter "foo" as secondary diagnosis
    And I press on "Fall Gruppieren"
    Then I should see "Nebendiagnosen: foo invalid"