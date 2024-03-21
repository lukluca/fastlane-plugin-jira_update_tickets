# frozen_string_literal: true

require 'fastlane/action'
require 'fastlane_core'

module Fastlane
  module Actions
    class JiraUpdateTicketsAction < Action
      # rubocop:disable Metrics/PerceivedComplexity
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/MethodLength
      def self.run(params)
        Actions.verify_gem!('jira-ruby')
        require 'jira-ruby'

        tickets = params[:tickets]

        tickets = [] if tickets.instance_of?(NilClass)

        exit(0) if tickets.empty?

        client = JIRA::Client.new(
          username: params[:username],
          password: params[:password],
          site: params[:url],
          context_path: '',
          auth_type: :basic
        )

        next_transition_name = params[:next_transition_name]
        fix_version = params[:fix_version]

        tickets.each do |ticket|
          issue = client.Issue.find(ticket)

          next if issue.instance_of?(NilClass)

          unless next_transition_name.instance_of?(NilClass)
            available_transitions = client.Transition.all(issue: issue)

            available_transitions = [] if available_transitions.instance_of?(NilClass)

            next_transition = available_transitions.find do |transition|
              transition.to.name == next_transition_name
            end

            unless next_transition.instance_of?(NilClass)
              # ticket can go to desired status
              transition = issue.transitions.build
              transition.save!('transition' => { 'id' => next_transition.id })
            end
          end

          next if fix_version.instance_of?(NilClass)

          issue.save({
                       'fields' => {
                         'fixVersions' => [{
                           'name' => fix_version
                         }]
                       }
                     })
        end
      end
      # rubocop:enable Metrics/PerceivedComplexity
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/MethodLength

      def self.description
        'Update status and fix version of provided jira tickets'
      end

      def self.authors
        ['Luca Tagliabue']
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        'The aim of this plugin is to help jira tickets managment setting fix version updating the status'
      end

      # rubocop:disable Metrics/MethodLength
      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :url,
                                       env_name: 'FL_JIRA_SITE',
                                       description: 'URL for Jira instance',
                                       sensitive: true,
                                       type: String,
                                       verify_block: ->(value) { verify_option(key: 'url', value: value) }),
          FastlaneCore::ConfigItem.new(key: :username,
                                       env_name: 'FL_JIRA_USERNAME',
                                       description: 'Username for Jira instance',
                                       sensitive: true,
                                       type: String,
                                       verify_block: ->(value) { verify_option(key: 'username', value: value) }),
          FastlaneCore::ConfigItem.new(key: :password,
                                       env_name: 'FL_JIRA_PASSWORD',
                                       description: 'Password or api token for Jira',
                                       sensitive: true,
                                       type: String,
                                       verify_block: ->(value) { verify_option(key: 'password', value: value) }),
          FastlaneCore::ConfigItem.new(key: :tickets,
                                       description: 'Array of Strings. Each value is a JIRA ticket name',
                                       type: Array,
                                       verify_block: lambda { |value|
                                                       FastlaneCore::UI.user_error!("No value found for 'tickets'") if Array(value).empty?
                                                     }),
          FastlaneCore::ConfigItem.new(key: :next_transition_name,
                                       description: 'New transition name of the ticket',
                                       type: String,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :fix_version,
                                       description: 'Fix version of the ticket',
                                       type: String,
                                       optional: true)
        ]
      end
      # rubocop:enable Metrics/MethodLength

      def self.verify_option(options)
        FastlaneCore::UI.user_error!("No value found for '#{options[:key]}'") if options[:value].to_s.empty?
      end

      def self.example_code
        [
          'jira_update_tickets(
              url: "YOUR_URL_HERE",
              username: "YOUR_USERNAME_HERE",
              password: "YOUR_PASSWORD_HERE",
              tickets: ["ISSUE-1"]
          )'
        ]
      end

      def self.is_supported?(_platform)
        true
      end
    end
  end
end
