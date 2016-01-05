require 'spec_helper'

describe SlackMetabot::Commands::Default do
  let!(:team) { Fabricate(:team) }
  let(:app) { SlackMetabot::Server.new(team: team) }
  before do
    # the additional GIF
    expect(SlackRubyBot::Commands::Base).to receive(:send_client_message).with(app.send(:client), channel: 'channel', text: '')
  end
  it 'default' do
    expect(message: SlackRubyBot.config.user).to respond_with_slack_message(SlackMetabot::INFO)
  end
  it 'upcase' do
    expect(message: SlackRubyBot.config.user.upcase).to respond_with_slack_message(SlackMetabot::INFO)
  end
end
