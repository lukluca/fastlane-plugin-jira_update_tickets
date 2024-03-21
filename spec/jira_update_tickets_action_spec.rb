describe Fastlane::Actions::JiraUpdateTicketsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The jira_update_tickets plugin is working!")

      Fastlane::Actions::JiraUpdateTicketsAction.run(nil)
    end
  end
end
