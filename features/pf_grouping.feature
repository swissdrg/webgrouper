Feature: Group a pf patient case

  Scenario: A random valid patient case
    Given the form with initialized standard values

    When I enter "S39.80" as diagnosis
    And I press on "Fall Gruppieren"

    Then the grouping should succeed
    And I should see "21B" in result
    And I should see "X60Z" in result