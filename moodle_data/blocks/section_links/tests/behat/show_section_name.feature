@block @block_section_links
Feature: The Section links block can be configured to display section name in addition to section number

  Background:
    Given the following "course" exists:
      | fullname      | Course 1 |
      | shortname     | C1       |
      | category      | 0        |
      | numsections   | 10       |
      | coursedisplay | 1        |
      | initsections  | 1        |
    And the following "activities" exist:
      | activity | name              | course | idnumber | section |
      | assign   | First assignment  | C1     | assign1  | 7       |
    And the following "users" exist:
      | username | firstname | lastname | email |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
      | student1 | Student   | 1        | student1@example.com |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |
    And the following config values are set as admin:
      | showsectionname | 1 | block_section_links |
      | unaddableblocks | | theme_boost|
    And the following "blocks" exist:
      | blockname     | contextlevel | reference | pagetypepattern | defaultregion |
      | section_links | Course       | C1        | course-view-*   | side-pre      |

  Scenario: Student can see section name under the Section links block
    When I am on the "Course 1" course page logged in as student1
    Then I should see "7: Section 7" in the "Section links" "block"
    And I follow "7: Section 7"
    And I should see "First assignment"

  Scenario: Teacher can configure existing Section links block to display section number or section name
    Given I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    When I configure the "Section links" block
    And I set the following fields to these values:
      | Display section name | No |
    And I click on "Save changes" "button"
    Then I should not see "7: Section 7" in the "Section links" "block"
    And I should see "7" in the "Section links" "block"
    And I follow "7"
    And I should see "First assignment"

  Scenario: Subsections names are not displayed in the Section links block
    Given I enable "subsection" "mod" plugin
    And the following "activity" exists:
      | activity | subsection  |
      | name     | Subsection1 |
      | course   | C1          |
      | idnumber | subsection1 |
      | section  | 1           |
    When I am on the "Course 1" course page logged in as student1
    Then I should not see "Subsection1" in the "Section links" "block"
