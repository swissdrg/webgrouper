Feature: The system 14 should work as intended. Right now this is not tested.
  Any user

  @javascript @wip
  Scenario: Admission should make a difference for O80 with given values
    Given the beta form
    And I enter "O80" as diagnosis
    And I select "days" as age mode
    And I enter "1" as age
    And I enter "1" as los
    And I select system 14
    And I submit the form
    Then I should see "P60B" in "grouping"
    When I select "diseased" as sep mode
    And I submit the form
    Then I should see "P60A" in "grouping"

  @javascript @wip
  Scenario: The kernel of version 3 should be in use
    Given the beta form
    And I select birthhouse as care taker
    And I enter "A01.2" as diagnosis
    And I select "days" as age mode
    And I enter "1" as age
    And I submit the form
    Then I should see "P60C" in "grouping"
    When I select system 14
    And I submit the form
    Then I should see "P60D" in "grouping"