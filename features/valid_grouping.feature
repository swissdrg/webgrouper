Feature: Group a valid patient case
  In order to blah
  A normal user
  Should group without any conflicts and validation errors

  Scenario: A random valid patient case
    Given the form with initialized standard values

    When I enter some random (valid!) data
    And I press on "Fall Gruppieren"

    Then the grouping should succeed
    And the result should be shown