Feature: When birthhouse is entered as caretaker, the correct values should be computed

  Scenario: Milzbrand in birthhouse should not be treated as valid in V1.0
    Given the form with initialized standard values
    When I enter "A22.1" as diagnosis
    And I submit the form
    Then I should see "1.343" in "cost-weight"
    When I select birthhouse as care taker
    And I submit the form
    Then I should see "0" in "cost-weight"
    
  Scenario: Milzbrand in birthhouse should have result in V2.0
    Given the form with initialized standard values
    When I select "SwissDRG 2.0 Planungsversion 2" as system
    When I enter "A22.1" as diagnosis
    And I submit the form
    Then I should see "1.182" in "cost-weight"
    And I should see "E77C" in "grouping"
    When I select birthhouse as care taker
    And I submit the form
    Then I should see "0.557" in "cost-weight"
	And I should see "0.647" in "cost-weight"
	And I should see "O60C" in "grouping"

