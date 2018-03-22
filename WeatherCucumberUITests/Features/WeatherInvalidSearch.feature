Feature: Invalid Search

@NoResults
Scenario: Unable to search Weather

    Given I am on Weather Search Screen
    When I search for "ZZZ"
    Then I should see Empty State on results
