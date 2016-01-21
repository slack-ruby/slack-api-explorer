require 'spec_helper'

describe SlackRubyBot::Commands::Unknown, vcr: { cassette_name: 'user_info' } do
  let!(:team) { Fabricate(:team) }
  let(:app) { SlackApiExplorer::Server.new(team: team) }
  let(:client) { app.send(:client) }
  it 'invalid command' do
    expect(message: "#{SlackRubyBot.config.user} foobar").to respond_with_slack_message("```\nerror: Unknown command 'foobar'```")
  end
  it 'does not respond to sad face' do
    expect(SlackRubyBot::Commands::Base).to_not receive(:send_message)
    SlackApiExplorer::Server.new(team: team).send(:message, client, text: ':((')
  end
end
