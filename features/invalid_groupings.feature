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
    
    
  @mac @javascript
  Scenario: Submit the form with invalid secondary diagnoses
    Given the form with initialized standard values
    When I enter the secondary diagnoses "foo", "bar", "bat", "dani", "randy", "test", "hallo", "yeeah"
    And I press on "Fall Gruppieren"
    Then I should see "Nebendiagnosen: foo invalid"
    And I should see "Nebendiagnosen: bar invalid"
    And I should see "Nebendiagnosen: bat invalid"
    And I should see "Nebendiagnosen: dani invalid"
    And I should see "Nebendiagnosen: randy invalid"
    And I should see "Nebendiagnosen: test invalid"
    And I should see "Nebendiagnosen: hallo invalid"
    And I should see "Nebendiagnosen: yeeah invalid"
    
  @mac @javascript
  Scenario: Submit the form with invalid procedures
    Given the form with initialized standard values
    When I enter the procedures "foo", "bar", "bat", "dani", "randy", "test", "hallo", "yeeah"
    And I press on "Fall Gruppieren"
    Then I should see "Prozeduren: foo"
    And I should see "Prozeduren: bar"
    And I should see "Prozeduren: bat"
    And I should see "Prozeduren: dani"
    And I should see "Prozeduren: randy"
    And I should see "Prozeduren: test"
    And I should see "Prozeduren: hallo"
    And I should see "Prozeduren: yeeah"
  