@EPMCDMETST-63402 @tags @regression
Feature: Tag/Label system for OpenTodoList items
  Tags allow categorization and filtering across libraries and views.
  Tags must be validated, normalized, limited to 20 per item, persisted, and backward compatible.

  Background:
    Given an OpenTodoList item exists

  @validation
  Scenario Outline: Accept only valid tag names and normalize to lowercase + trimmed
    When the user adds tag "<input>"
    Then the operation result is "<result>"
    And the item tags contain "<expected>" if result is "success"
    And the tags last error is "<error>" if result is "failure"

    Examples:
      | input        | result  | expected     | error                                                                             |
      | urgent       | success | urgent      |                                                                                        |
      |  Urgent     | success | urgent      |                                                                                        |
      | project-x    | success | project-x   |                                                                                       |
      | phone_call  | success | phone_call |                                                                                        |
      | proj$ct     | failure |           | Tag "proj4ct" contains invalid characters. Only a-z,0-9, _ and - are allowed. |
      | white space | failure |           | Tag "white space" contains invalid characters. Only a-z,0-9, _ and - are allowed. |
      |           | failure |           | Tag must not be empty. |

  @limit
  Scenario: Enforce maximum of 20 tags per item
    Given the item has 20 valid tags
    When the user adds tag "extra"
    Then the operation result is "failure"
    And the item tags count is 20
    And the tags last error is "Maximum 20 tags per item."

  @dedupe
  Scenario: De-duplicate tags (case-insensitive due to normalization)
    When the user adds tag "Urgent"
    And the user adds tag "urgent"
    Then the operation result is "success"
    And the item tags count is 1
    And the item tags contain "urgent"
    And the tags last error is ""

  @persistence
  Scenario: Persist tags to map only when non-empty and restore after reload
    Given the item has tags "urgent" and "backend"
    When the item is serialized to a map
    Then the map contains key "tags" with array "urgent","backend"
    When a new item is created from that map
    Then the new item tags are "urgent","backend"

  @backward_compatibility
  Scenario: Load legacy item map without tags key (no schema migration required)
    Given a legacy item map without "tags"
    When a new item is created from that map
    Then the new item tags are empty
    And no error is raised

  @load_sanitization
  Scenario: Sanitize invalid/too-many tags on load without failing
    Given an item map contains tags "ok","bad$","OK","", "t01","t02","t03","t04","t05","t06","t07","t08","t09","t10","t11","t12","t13","t14","t15","t16","t17","t18","t19","t20","t21"
    When a new item is created from that map
    Then the new item tags do not contain "bad$"
    And the new item tags contain "ok"
    And the new item tags count is 20

  @filtering
  Scenario: Filter items model by tag (case-insensitive)
    Given an items model with items:
      | title | tags              |
      | A    | urgent,backend     |
      | B    | backend            |
      | C    |                    |
    When filterTag is set to "Urgent"
    Then only items "A" are visible
    When filterTag is set to ""
    Then items "A","B","C" are visible

  @filtering_toggle_ui
  Scenario: Selecting an already-selected tag clears the filter (behavioral contract)
    Given the active tag filter is ""
    When the user selects tag filter "urgent"
    Then the active tag filter is "urgent"
    When the user selects tag filter "urgent" again
    Then the active tag filter is ""

  @query
  Scenario: Query cached items by tag returns only matching entries
    Given the cache contains items with tags:
      | uid  | tags        |
      | u-1  |  phone,home  |
      | u-2  |  work        |
      | u-3  |  phone       |
    When GetItemsByTagQuery is executed for "PHONE"
    Then the returned uids are "u-1","u-3"
