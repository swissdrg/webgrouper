Feature: The system should be changable in the form
  Any user
  
  Scenario: Start with System 9 and change to System 11
  	Given the form with initialized standard values
    And I select system 9
  	And I enter "Q28.81" as diagnosis
  	And I enter "30" as hmv
  	And I submit the form
  	Then I should see "2.762" in "cost-weight"
  	When I select system 11
  	And I submit the form
  	Then I should see "2.111" in "cost-weight"
  	
  Scenario: Start with System 9 and change to System 12
  	Given the form with initialized standard values
  	When  I select system 9
  	And I enter "Q28.81" as diagnosis
  	And I enter "30" as hmv
  	And I submit the form
  	Then I should see "2.762" in "cost-weight"
  	When  I select system 12
  	And I submit the form
  	Then I should see "2.111" in "cost-weight"
  	