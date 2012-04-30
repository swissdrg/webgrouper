Feature: Transfer should be handled correctly
  A normal user
  Should group without any conflicts and validation errors, when entering a valid case, even with transfer
  
  Scenario: Strahlenzystis mit los 3 und Transfer
    Given the form with initialized standard values

    When I enter "N30.4" as diagnosis
    And I enter "3" as los
    And I enter Transfered (los more than 24 hours) as admission mode
    And I press on "Fall Gruppieren"

    Then the grouping should succeed
    And I should see "11" in "grouping"
    And I should see "L62B" in "grouping"
    And I should see "Normale Gruppierung" in "grouping"
    And I should see "0.68" in "cost-weight"
    And I should see "0.4616" in "cost-weight"
    And I should see "Strahlenzystitis" in "diagnoses"
    And I should see "N30.4" in "diagnoses"
    And I should see "Verlegungsabschlagspflichtig" in "length-of-stay"