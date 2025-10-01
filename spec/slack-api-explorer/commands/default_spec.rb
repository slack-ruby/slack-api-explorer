require 'spec_helper'

describe SlackApiExplorer::Commands::Default do
  let!(:team) { Fabricate(:team) }
  let(:app) { SlackApiExplorer::Server.new(team: team) }
  let(:client) { app.send(:client) }
  let(:message_hook) { SlackRubyBot::Hooks::Message.new }

  it 'default' do
    expect(client).to receive(:say).with(channel: 'channel', text: SlackApiExplorer::INFO)
    message_hook.call(client, Hashie::Mash.new(channel: 'channel', text: SlackRubyBot.config.user))
  end

  it 'upcase' do
    expect(client).to receive(:say).with(channel: 'channel', text: SlackApiExplorer::INFO)
    message_hook.call(client, Hashie::Mash.new(channel: 'channel', text: SlackRubyBot.config.user.upcase))
  end
end
