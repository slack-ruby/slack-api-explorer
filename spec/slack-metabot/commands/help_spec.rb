require 'spec_helper'

describe SlackMetabot::Commands::Help do
  let!(:team) { Fabricate(:team) }
  let(:app) { SlackMetabot::Server.new(team: team) }
  it 'help' do
    expect(SlackRubyBot::Commands::Base).to receive(:send_client_message).with(app.send(:client), channel: 'channel', text: '')
    expect(message: "#{SlackRubyBot.config.user} help").to respond_with_slack_message([SlackMetabot::Commands::Help::HELP, SlackMetabot::INFO].join("\n"))
  end
end
