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

require 'open_project/plugins'

module OpenProject::Reminder
  class Engine < ::Rails::Engine
    engine_name :openproject_reminder

    include OpenProject::Plugins::ActsAsOpEngine

    register 'openproject-reminder',
             author_url: 'http://finn.de',
             requires_openproject: '>= 4.0.0' do

      project_module :reminders do
        permission :create_reminders, { reminders: [:new, :create, :copy] }, require: :member
        permission :edit_reminders, { reminders: [:edit, :update] }, require: :member
        permission :delete_reminders, { reminders: [:destroy] }, require: :member
        permission :reminders_send_invite, { reminders: [:icalendar] }, require: :member
        permission :view_reminders, reminders: [:index, :show], reminder_agendas: [:history, :show, :diff], reminder_minutes: [:history, :show, :diff]
        permission :create_reminder_agendas, { reminder_agendas: [:update, :preview] }, require: :member
        permission :close_reminder_agendas, { reminder_agendas: [:close, :open] }, require: :member
        permission :send_reminder_agendas_notification, { reminder_agendas: [:notify] }, require: :member
        permission :send_reminder_agendas_icalendar, { reminder_agendas: [:icalendar] }, require: :member
        permission :create_reminder_minutes, { reminder_minutes: [:update, :preview] }, require: :member
        permission :send_reminder_minutes_notification, { reminder_minutes: [:notify] }, require: :member
      end

      Redmine::Search.map do |search|
        search.register :reminders
      end

      menu :project_menu, :reminders, { controller: '/reminders', action: 'index' },
           caption: :project_module_reminders,
           param: :project_id,
           after: :wiki,
           html: { class: 'icon2 icon-reminders' }

      ActiveSupport::Inflector.inflections do |inflect|
        inflect.uncountable 'reminder_minutes'
      end

      Redmine::Activity.map do |activity|
        activity.register :reminders, class_name: 'Activity::ReminderActivityProvider', default: false
      end
    end

    patches [:Project]
    patch_with_namespace :BasicData, :RoleSeeder
    patch_with_namespace :BasicData, :SettingSeeder

    initializer 'reminder.precompile_assets' do
      Rails.application.config.assets.precompile += %w(reminder/reminder.css)
    end

    initializer 'reminder.register_hooks' do
      require 'open_project/reminder/hooks'
    end

    #initializer 'reminder.register_latest_project_activity' do
      #Project.register_latest_project_activity on: OpenProject::Reminder,
                                               #attribute: :updated_at
    #end

    config.to_prepare do
      # load classes so that all User.before_destroy filters are loaded
      require_dependency 'reminder'
      require_dependency 'reminder_agenda'
      require_dependency 'reminder_minutes'
      require_dependency 'reminder_participant'

      #PermittedParams.permit(:search, :reminders)
      PermittedParams.permitted_attributes.merge({:search => :reminders})
    end
  end
end
