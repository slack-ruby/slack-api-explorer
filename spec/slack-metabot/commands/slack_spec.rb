require 'spec_helper'

describe SlackMetabot::Commands::Slack do
  let!(:team) { Fabricate(:team) }
  let(:app) { SlackMetabot::Server.new(team: team) }
  it 'auth' do
    expect(message: "#{SlackRubyBot.config.user} auth").to respond_with_slack_message("```\nerror: Command 'auth' requires a subcommand test```")
  end
end
