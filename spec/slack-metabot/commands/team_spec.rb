require 'spec_helper'

describe SlackMetabot::Commands::Team, vcr: { cassette_name: 'user_info' } do
  let!(:team) { Fabricate(:team) }
  let(:app) { SlackMetabot::Server.new(team: team) }
  it 'team' do
    expect(message: "#{SlackRubyBot.config.user} team").to respond_with_slack_message "Team _#{team.name}_."
  end
end
