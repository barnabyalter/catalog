@javascript
@marc
@wip

Feature:
  In order to see if library items are available
  As a library patron
  I should see holdings information displayed in searches

  Scenario: Viewing item in CWRU opac (BL-99)
    Given I am on the bib record page for 45080162
    Then I should see "Holdings"
    And I should see "Rock Hall Reference"

  Scenario: Access to Serials Holdings via Bib Record (BL-181)
    Given I am on the bib record page for 1478478
    Then I should see "Click for Holdings"
    Given I am on the bib record page for 702358017
    Then I should not see "Click for Holdings"

  Scenario: Status display for bib searches (BL-103)
    Given I am on the home page
    And I fill in "q" with "Kennedy"
    When I press "search"
    Then I should see "Copies Available"

  Scenario: Search results should display an unknown status if III is down (DAM-233)
    Given I am on the home page
    And the opac is down
    And I fill in "q" with "How to analyze the music of Bob Dylan"
    When I press "search"
    And I wait for "7" seconds
    Then I should see "Unknown"