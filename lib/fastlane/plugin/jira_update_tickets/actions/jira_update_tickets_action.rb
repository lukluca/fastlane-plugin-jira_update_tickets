require 'fastlane/action'
require_relative '../helper/jira_update_tickets_helper'

module Fastlane
  module Actions
    class JiraUpdateTicketsAction < Action
      def self.run(params)
        UI.message("The jira_update_tickets plugin is working!")
      end

      def self.description
        "Update status and fix version of provided jira tickets"
      end

      def self.authors
        ["Luca Tagliabue"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "The aim of this plugin is to help jira tickets managment setting fix version updating the status"
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "JIRA_UPDATE_TICKETS_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
