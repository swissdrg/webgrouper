Feature: The edge cases should be handled correctly
  Any user
  
  @javascript
  Scenario: Just parse some stuff
	Given the form with initialized standard values
	When I parse "1;5;;;M;01;01;3;0;0;I130;;;;;;" as input for the form
	
  @unfinished 
  Scenario: Case for reuptake
  	Given the form with initialized standard values
  	When I enter "Q28.81" as diagnosis
  	And I enter "30" as hmv
  	And I submit the form
  	Then I should see something about reuptake