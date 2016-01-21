require 'spec_helper'

describe SlackApiExplorer::Commands::Slack do
  let!(:team) { Fabricate(:team) }
  let(:app) { SlackApiExplorer::Server.new(team: team) }
  it 'auth' do
    expect(message: "#{SlackRubyBot.config.user} auth").to respond_with_slack_message("```\nerror: Command 'auth' requires a subcommand test```")
  end
  context 'auth test' do
    let(:json) do
      {
        ok: true,
        url: 'https://dblockdotorg.slack.com/',
        team: 'dblock',
        user: 'rubybot',
        team_id: 'T04KB5WQH',
        user_id: 'U07518DTL'
      }
    end
    before do
      allow(SlackApiExplorer::Commands::Slack).to receive(:execute).and_yield(JSON.dump(json), nil)
    end
    it 'returns raw json' do
      expect(message: "#{SlackRubyBot.config.user} auth test").to respond_with_slack_message("```\n#{JSON.pretty_generate(json)}```")
    end
    it 'processes a json value' do
      expect(message: "#{SlackRubyBot.config.user} auth test | $.team_id").to respond_with_slack_message("```\n[\n  \"T04KB5WQH\"\n]```")
    end
    it 'responds to a slack ID' do
      expect(message: "<@#{SlackRubyBot.config.user_id}>: auth test").to respond_with_slack_message("```\n#{JSON.pretty_generate(json)}```")
    end
  end
  context 'channels list' do
    let(:json) do
      {
        ok: true,
        channels: [
          {
            id: 'C09C5GYHF',
            name: 'general',
            is_channel: true,
            created: 1_440_078_580,
            creator: 'U04KB5WQR',
            is_archived: false,
            is_general: true,
            is_member: true,
            members: ['U07518DTL'],
            num_members: 0
          },
          {
            id: 'C09C598QL',
            name: 'random',
            is_channel: true,
            created: 1_440_078_625,
            creator: 'U04KB5WQR',
            is_archived: true,
            is_general: false,
            is_member: false,
            members: %w(U07518DTL U12345ABC),
            num_members: 0
          }
        ]
      }
    end
    before do
      allow(SlackApiExplorer::Commands::Slack).to receive(:execute).and_yield(JSON.dump(json), nil)
    end
    it 'returns multiple json values' do
      expect(message: "#{SlackRubyBot.config.user} channels list | $..name").to respond_with_slack_message("```\n[\n  \"general\",\n  \"random\"\n]```")
    end
    it 'returns general channel' do
      output = JSON.pretty_generate([json[:channels][0]])
      expect(message: "#{SlackRubyBot.config.user} channels list | $..[?(@.name=='general')]").to respond_with_slack_message("```\n#{output}```")
    end
    it 'returns id of the general channel' do
      expect(message: "#{SlackRubyBot.config.user} channels list | $..[?(@.name=='general')].id").to respond_with_slack_message("```\n[\n  \"C09C5GYHF\"\n]```")
    end
  end
end
