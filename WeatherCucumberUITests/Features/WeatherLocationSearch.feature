Feature: Weather Location Search

Scenario: Able to search Weather
 
    Given I am on Weather Search Screen
    When I search for "Tokyo"
    Then I should see "Tokyo" in results

    When I tap "Tokyo" in results
    Then I should be on Weather Detail Screen

    Then I should see "Tokyo" in Detail Screen
    Then I should see "Japan" in Detail Screen
    Then I should see "9" in Detail Screen
    Then I should see "Cloudy" in Detail Screen


Scenario: Able to clear search bar and return to default state

    Given I am on Weather Search Screen
    When I search for "France"
    When I clear search bar
    Then I should see Default State on results
