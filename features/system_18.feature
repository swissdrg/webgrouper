Feature: The system 18 should work as intended.
  Any user

  @javascript
  Scenario: The new grouper kernel should deliver correct result
    Given the beta form
    And I select system 17
    And I select "W" as sex
    And I enter "1" as age
    And I select "days" as age mode
    And I enter "E241" as diagnosis
    And I enter "922300" as procedure
    And I submit the form
    Then I should see "P05C" in "grouping"

    When I select birthhouse as care taker
    And I submit the form
    Then I should see "P60D" in "grouping"

    When I select system 18
    And I submit the form
    Then I should see "P60C" in "grouping"

    When I select hospital as care taker
    And I submit the form
    Then I should see "P05C" in "grouping"

