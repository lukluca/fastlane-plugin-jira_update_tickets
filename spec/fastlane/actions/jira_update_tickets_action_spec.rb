# frozen_string_literal: true

describe Fastlane::Actions::JiraUpdateTicketsAction do
  describe '#run' do
    context 'without required variables raises an error' do
      it 'if url was not given' do
        expect do
          Fastlane::FastFile.new.parse("
        lane :test do
          jira_update_tickets(
            username: 'YOUR_USERNAME_HERE',
            password: 'YOUR_PASSWORD_HERE',
            tickets: ['ISSUE-1']
        )
        end").runner.execute(:test)
        end.to raise_error("No value found for 'url'")
      end

      it 'if username was not given' do
        expect do
          Fastlane::FastFile.new.parse("
        lane :test do
          jira_update_tickets(
            url: 'YOUR_URL_HERE',
            password: 'YOUR_PASSWORD_HERE',
            tickets: ['ISSUE-1']
        )
        end").runner.execute(:test)
        end.to raise_error("No value found for 'username'")
      end

      it 'if password was not given' do
        expect do
          Fastlane::FastFile.new.parse("
          lane :test do
            jira_update_tickets(
              url: 'YOUR_URL_HERE',
              username: 'YOUR_USERNAME_HERE',
              tickets: ['ISSUE-1']
          )
          end").runner.execute(:test)
        end.to raise_error("No value found for 'password'")
      end

      it 'if tickets was not given' do
        expect do
          Fastlane::FastFile.new.parse("
          lane :test do
            jira_update_tickets(
              url: 'YOUR_URL_HERE',
              password: 'YOUR_PASSWORD_HERE',
              username: 'YOUR_USERNAME_HERE'
          )
          end").runner.execute(:test)
        end.to raise_error("No value found for 'tickets'")
      end

      it 'if empty url was given' do
        expect do
          Fastlane::FastFile.new.parse("
          lane :test do
            jira_update_tickets(
              url: '',
              username: 'YOUR_USERNAME_HERE',
              password: 'YOUR_PASSWORD_HERE',
              tickets: ['ISSUE-1']
          )
          end").runner.execute(:test)
        end.to raise_error("No value found for 'url'")
      end

      it 'if empty username was given' do
        expect do
          Fastlane::FastFile.new.parse("
          lane :test do
            jira_update_tickets(
              url: 'YOUR_URL_HERE',
              username: '',
              password: 'YOUR_PASSWORD_HERE',
              tickets: ['ISSUE-1']
          )
          end").runner.execute(:test)
        end.to raise_error("No value found for 'username'")
      end

      it 'if empty password was given' do
        expect do
          Fastlane::FastFile.new.parse("
          lane :test do
            jira_update_tickets(
              url: 'YOUR_URL_HERE',
              username: 'YOUR_USERNAME_HERE',
              password: '',
              tickets: ['ISSUE-1']
          )
          end").runner.execute(:test)
        end.to raise_error("No value found for 'password'")
      end

      it 'if empty tickets was given' do
        expect do
          Fastlane::FastFile.new.parse("
          lane :test do
            jira_update_tickets(
              url: 'YOUR_URL_HERE',
              username: 'YOUR_USERNAME_HERE',
              password: 'YOUR_PASSWORD_HERE',
              tickets: []
          )
          end").runner.execute(:test)
        end.to raise_error("No value found for 'tickets'")
      end
    end

    context 'with variables given through invocation' do
      it 'succeeds with required variables' do
        stub_get_issue

        response = Fastlane::FastFile.new.parse("
            lane :test do
            jira_update_tickets(
              url: 'https://jira-myCompany.atlassian.net',
              username: 'my_username',
              password: 'my_password',
              tickets: ['ISSUE-1']
          )
          end").runner.execute(:test)
        expect(response).to eq(['ISSUE-1'])
      end

      it 'succeeds with next_transition_name variable' do
        stub_get_issue
        stub_get_transitions
        stub_post_save_transition

        response = Fastlane::FastFile.new.parse("
        lane :test do
          jira_update_tickets(
            url: 'https://jira-myCompany.atlassian.net',
            username: 'my_username',
            password: 'my_password',
            tickets: ['ISSUE-1'],
            next_transition_name: 'Next_Status'
        )
        end").runner.execute(:test)
        expect(response).to eq(['ISSUE-1'])
      end

      it 'succeeds with fix_version variable' do
        stub_get_issue
        stub_post_save_issue

        response = Fastlane::FastFile.new.parse("
        lane :test do
          jira_update_tickets(
            url: 'https://jira-myCompany.atlassian.net',
            username: 'my_username',
            password: 'my_password',
            tickets: ['ISSUE-1'],
            fix_version: '1.0.0'
        )
        end").runner.execute(:test)
        expect(response).to eq(['ISSUE-1'])
      end

      it 'fails' do
        stub_failed_get_issue

        Fastlane::FastFile.new.parse("
        lane :test do
          jira_update_tickets(
            url: 'https://jira-myCompany.atlassian.net',
            username: 'my_username',
            password: 'my_password',
            tickets: ['ISSUE-1']
        )
        end").runner.execute(:test)
      rescue StandardError => e
        expect(e.message).to eq("undefined method `presence' for an instance of String")
      end
    end

    it 'supports ios' do
      expect(described_class.is_supported?(:ios)).to be(true)
    end

    it 'supports android' do
      expect(described_class.is_supported?(:android)).to be(true)
    end

    it 'supports mac' do
      expect(described_class.is_supported?(:mac)).to be(true)
    end

    it 'has correct description' do
      expect(described_class.description).to eq('Update status and fix version of provided jira tickets')
    end

    it 'has correct details' do
      expect(described_class.details).to eq('The aim of this plugin is to help jira tickets managment setting fix version updating the status')
    end

    it 'has correct authors' do
      expect(described_class.authors).to eq(['Luca Tagliabue'])
    end

    it 'has correct output' do
      expect(described_class.output).to be_nil
    end

    it 'has correct return_value' do
      expect(described_class.return_value).to be_nil
    end
  end
end

# rubocop:disable Metrics/MethodLength
def stub_get_issue
  url = 'https://jira-mycompany.atlassian.net/rest/api/2/issue/ISSUE-1'

  stub_request(:get, url)
    .with(
      headers: {
        'Accept' => 'application/json',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => 'Basic bXlfdXNlcm5hbWU6bXlfcGFzc3dvcmQ=',
        'User-Agent' => 'Ruby'
      }
    )
    .to_return(status: 200, body: '{ "id": "155573", "self": "https://jira-mycompany.atlassian.net/rest/api/2/issue/10","key": "ISSUE-1"}', headers: {})
end
# rubocop:enable Metrics/MethodLength

# rubocop:disable Metrics/MethodLength
def stub_get_transitions
  url = 'https://jira-mycompany.atlassian.net/rest/api/2/issue/10/transitions?expand=transitions.fields'

  stub_request(:get, url)
    .with(
      headers: {
        'Accept' => 'application/json',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => 'Basic bXlfdXNlcm5hbWU6bXlfcGFzc3dvcmQ=',
        'User-Agent' => 'Ruby'
      }
    )
    .to_return(status: 200, body: '{
      "transitions": [{
          "id": "1",
          "name": "Next_Status",
          "to": {
              "self": "https://jira-mycompany.atlassian.net/rest/api/2/status/1",
              "description": "",
              "iconUrl": "https://jira-mycompany.atlassian.net/images/icons/statuses/generic.png",
              "name": "Next_Status",
              "id": "12161",
              "statusCategory": {
                  "self": "https://jira-mycompany.atlassian.net/rest/api/2/statuscategory/1",
                  "id": 1,
                  "key": "next_status",
                  "colorName": "blue",
                  "name": "Next_Status"
              }
          },
          "hasScreen": false,
          "isGlobal": true,
          "isInitial": false,
          "isAvailable": true,
          "isConditional": false,
          "isLooped": false
      }]
    }', headers: {})
end
# rubocop:enable Metrics/MethodLength

# rubocop:disable Metrics/MethodLength
def stub_post_save_transition
  url = 'https://jira-mycompany.atlassian.net/rest/api/2/issue/155573/transitions'

  stub_request(:post, url)
    .with(
      body: '{"transition":{"id":"1"}}',
      headers: {
        'Accept' => 'application/json',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => 'Basic bXlfdXNlcm5hbWU6bXlfcGFzc3dvcmQ=',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Ruby'
      }
    )
    .to_return(status: 200, body: '', headers: {})
end
# rubocop:enable Metrics/MethodLength

# rubocop:disable Metrics/MethodLength
def stub_post_save_issue
  url = 'https://jira-mycompany.atlassian.net/rest/api/2/issue/10'

  stub_request(:put, url)
    .with(
      body: '{"fields":{"fixVersions":[{"name":"1.0.0"}]}}',
      headers: {
        'Accept' => 'application/json',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => 'Basic bXlfdXNlcm5hbWU6bXlfcGFzc3dvcmQ=',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Ruby'
      }
    )
    .to_return(status: 200, body: '', headers: {})
end
# rubocop:enable Metrics/MethodLength

# rubocop:disable Metrics/MethodLength
def stub_failed_get_issue
  url = 'https://jira-mycompany.atlassian.net/rest/api/2/issue/ISSUE-1'

  stub_request(:get, url)
    .with(
      headers: {
        'Accept' => 'application/json',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization' => 'Basic bXlfdXNlcm5hbWU6bXlfcGFzc3dvcmQ=',
        'User-Agent' => 'Ruby'
      }
    )
    .to_return(status: 401, body: '', headers: {})
end
# rubocop:enable Metrics/MethodLength
