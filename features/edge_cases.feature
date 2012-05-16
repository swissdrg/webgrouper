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
  	Then I should see "Die DRG F43C ist von einer Fallzusammenführung bei Wiederaufnahme ausgeschlossen." in "settlement_hints"
  
  @javascript @unfinished 
  Scenario: Case for additional fee
  	Given the form with initialized standard values
  	When I enter "B72" as diagnosis
  	And I enter "39.95.21" as procedure
  	And I submit the form
  	Then I should see "Hämodialyse, Hämodiafiltration, Hämofiltration, intermittierend" in "settlement_hints"
  	And I should see "ZE01-2012" in "settlement_hints"
  	And I should see "39.95.21" in "settlement_hints"
  	
  @javascript
  Scenario: Case for "Verlegungsabschlag"
    Given the form with initialized standard values
    When i parse "12;28;;;U;99;06;2;0;0;J632;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;" as input for the form
    Then I should see "E74Z" in groupings
  
  
  