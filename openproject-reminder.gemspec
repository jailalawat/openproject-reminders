# encoding: UTF-8
$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'open_project/reminder/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'openproject-reminder'
  s.version     = OpenProject::Reminder::VERSION
  s.authors     = 'Medulla Technologies'
  s.email       = 'support@medullatechnologies.com'
  s.homepage    = 'https://community.openproject.org/projects/plugin-reminders'
  s.summary     = 'OpenProject reminder'
  s.description = "This plugin adds functions to support project reminders to OpenProject. reminders
    can be scheduled selecting invitees from the same project to take part in the Reminder. An agenda
    can be created and sent to the invitees. After the reminder, attendees can be selected and
    minutes can be created based on the agenda. Finally, the minutes can be sent to all attendees
    and invitees."
  s.license     = 'GPLv3'

  s.files = Dir['{app,config,db,lib,doc}/**/*', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 4.2.7'
  s.add_dependency 'icalendar', '~> 2.3.0'

  s.add_development_dependency 'factory_girl_rails', '~> 4.0'
end
