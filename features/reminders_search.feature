#-- copyright
# OpenProject reminder Plugin
#
# Copyright (C) 2011-2014 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.md for more details.
#++

Feature: Search reminders through the global search

  Background:
        Given there is 1 project with the following:
              | identifier | dingens |
              | name       | dingens |
          And the project "dingens" uses the following modules:
              | reminders |
          And there is 1 user with:
              | login    | alice |
              | language | en    |
          And there is a role "user"
          And the role "user" may have the following rights:
              | view_reminders |
          And the user "alice" is a "user" in the project "dingens"
          And there is 1 user with:
              | login    | bob |
          And there is 1 reminder in project "dingens" created by "bob" with:
              | title      | Bobs reminder        |
              | location   | Room 2              |
              | duration   | 2:30                |
              | start_time | 2011-02-10 11:00:00 |
          And the reminder "Bobs reminder" has 1 agenda with:
              | locked | true   |
              | text   | foobaz |
          And the reminder "Bobs reminder" has minutes with:
              | text   | barbaz |

  @javascript
  Scenario: Navigate to the search page and search for a reminder
       When I am already logged in as "alice"
        And I go to the search page
        And I fill in the following:
            | search-input | bob |
        And I click on "Submit"
       Then I should see "Bobs reminder" within "#search-results .reminder"
