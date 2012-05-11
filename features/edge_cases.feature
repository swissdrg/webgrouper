Feature: The edge cases should be handled correctly
  Any user
  
  @unfinished @javascript
  Scenario: Just parse some stuff
	Given the form with initialized standard values
	When I parse "1;5;;;M;01;01;3;0;0;I130;;;;;;" as input for the form