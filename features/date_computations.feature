Feature: Arbitrary dates entered in admission date/date of discharge/leave days should lead to right result in length of stay

	@javascript
  Scenario: Switch between Summertime/Wintertime is in period
    Given the form with initialized standard values
    When I fill in "webgrouper_patient_case_entry_date" with "26.03.2012"
    And I fill in "webgrouper_patient_case_exit_date" with "29.05.2012"
    And I enter "A000" as diagnosis
    And I submit the form
    Then I should see "64" in "length-of-stay"