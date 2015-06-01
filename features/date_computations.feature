Feature: Arbitrary dates entered in admission date/date of discharge/leave days should lead to right result in length of stay

@javascript
  Scenario: Switch between Summertime/Wintertime is in period
    Given the form with initialized standard values
    When I fill in "webgrouper_patient_case_entry_date" with "26.03.2012"
    And I fill in "webgrouper_patient_case_exit_date" with "29.05.2012"
    And I enter "A000" as diagnosis
    And I submit the form
    Then I should see "64" in "length-of-stay"
    
@javascript
  Scenario: A full year with leap day should be calculated properly
    Given the form with initialized standard values
    When I fill in "webgrouper_patient_case_entry_date" with "26.03.2011"
    And I fill in "webgrouper_patient_case_exit_date" with "26.03.2012"
    And I enter "A000" as diagnosis
    And I submit the form
    Then I should see "366" in "length-of-stay"
    
@javascript
  Scenario: A full year without leap day should be calculated properly
    Given the form with initialized standard values
    When I fill in "webgrouper_patient_case_entry_date" with "26.03.2010"
    And I fill in "webgrouper_patient_case_exit_date" with "26.03.2011"
    And I enter "A000" as diagnosis
    And I submit the form
    Then I should see "365" in "length-of-stay"
    
@javascript
  Scenario: Age in days should depend on birth date and entry date
    Given the form with initialized standard values
    When I fill in "webgrouper_patient_case_entry_date" with "26.03.2010"
    And I fill in "webgrouper_patient_case_exit_date" with "26.03.2011"
    And I fill in "webgrouper_patient_case_birth_date" with "22.03.2010"
    And I enter "A000" as diagnosis
    And I submit the form
    Then the grouping should succeed
    And I should see "4" as age
    
@javascript
  Scenario: Entry date before birth date should be an error
    Given the form with initialized standard values
    When I fill in "webgrouper_patient_case_entry_date" with "26.03.2010"
    And I fill in "webgrouper_patient_case_exit_date" with "26.03.2011"
    And I fill in "webgrouper_patient_case_birth_date" with "27.03.2010"
    And I enter "A000" as diagnosis
    And I submit the form
    Then I should see "-1" as age
    And I should see "Geburtstag: muss am gleichen Datum oder vor" as error

@javascript
  Scenario: Only Birth date without entry date should leave age blank, throw error when grouping
    Given the form with initialized standard values
    And I fill in "webgrouper_patient_case_birth_date" with "27.03.2010"
    And I enter "A000" as diagnosis
    Then I should see "" as age
    And I submit the form
    Then I should see "" as age
    And I should see "Alter: muss ausgefüllt werden" as error
    
@javascript
  Scenario: First entering birth date should have same result as entering entry date first
    Given the form with initialized standard values
    And I fill in "webgrouper_patient_case_birth_date" with "22.03.2010"
    When I fill in "webgrouper_patient_case_entry_date" with "26.03.2010"
    And I fill in "webgrouper_patient_case_exit_date" with "26.03.2011"
    And I enter "A000" as diagnosis
    And I submit the form
    Then the grouping should succeed
    And I should see "4" as age

@javascript @date
  Scenario: Leap years should be handled in age computation
    Given the form with initialized standard values
    When I fill in "webgrouper_patient_case_entry_date" with "19.07.2013"
    And I fill in "webgrouper_patient_case_exit_date" with "30.07.2013"
    And I fill in "webgrouper_patient_case_birth_date" with "1.8.1943"
    And I enter "A000" as diagnosis
    And I submit the form
    Then the grouping should succeed
    And I should see "69" as age