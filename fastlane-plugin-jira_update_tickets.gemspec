lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/jira_update_tickets/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-jira_update_tickets'
  spec.version       = Fastlane::JiraUpdateTickets::VERSION
  spec.author        = 'Luca Tagliabue'
  spec.email         = 'lu.tagliabue@reply.it'

  spec.summary       = 'Update status and fix version of provided jira tickets'
  spec.homepage      = "https://github.com/lukluca/fastlane-plugin-jira_update_tickets"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.6'
end
