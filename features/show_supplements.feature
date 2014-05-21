Feature: Supplements should be shown for various procedures/Diagnoses combinations


  @javascript
  Scenario: Procedure 00.4A.01 should have a supplement in v3.0 Abrechnungsversion
    Given the form with initialized standard values
    And I select system 17
    When I enter the procedures "00.4A.01"
    And I enter "A000" as diagnosis
    And I submit the form
    Then I should see "G67C" in result
    And I should see "00.4A.01" in "result-procedures"
    And I should see "ZE-2014-25.01" in "settlement_hints"
    And I should see "Einsetzen von Coils (00.4A.01)" in "settlement_hints"

  @javascript
  Scenario: Settlements should be added up and not appear twice
    Given the form with initialized standard values
    And I select system 17
    When I enter the procedures "00.4A.01" 5 times
    And I enter "A000" as diagnosis
    And I submit the form
    Then I should see "G67C" in result
    And I should see "00.4A.01" in "result-procedures"
    And I should see "ZE-2014-25.01" in "settlement_hints"
    And I should see "Einsetzen von Coils (00.4A.01)" in "settlement_hints"
    And I should see "5" in "settlement_hints"

  @javascript
  Scenario: Procedure 00.4A.01 should have a supplement in v3.0 Katalogversion
    Given the form with initialized standard values 
    And I select system 14
    When I enter the procedures "00.4A.01"
    And I enter "A000" as diagnosis
    And I submit the form
    Then I should see "G67C" in result
    And I should see "00.4A.01" in "result-procedures"
    And I should see "ZE-2014-25.01" in "settlement_hints"
    And I should see "Einsetzen von Coils (00.4A.01)" in "settlement_hints"

  @javascript
  Scenario: Procedure 00.4A.01 should not have a supplement in V1.0 Abrechnungsversion
    Given the form with initialized standard values
    When I enter the procedures "00.4A.01"
    And I enter "A000" as diagnosis
    And I submit the form
    Then I should see "G67B" in result
    And I should see "00.4A.01" in "result-procedures"
    And I should see "Keine Zusatzentgelte" in "settlement_hints"