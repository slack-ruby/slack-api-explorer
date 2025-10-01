require 'spec_helper'

describe SlackApiExplorer::Commands::Help do
  let!(:team) { Fabricate(:team) }
  let(:app) { SlackApiExplorer::Server.new(team: team) }
  let(:client) { app.send(:client) }
  let(:message_hook) { SlackRubyBot::Hooks::Message.new }

  it 'displays help' do
    expect(message: "#{SlackRubyBot.config.user} help").to respond_with_slack_message(
      [
        SlackApiExplorer::Commands::Help::HELP,
        SlackApiExplorer::INFO
      ].join("\n")
    )
  end

  it 'displays command help' do
    expect(message: "#{SlackRubyBot.config.user} help auth").to respond_with_slack_message(
      "```\nNAME\nauth - Auth methods.\n\nSYNOPSIS\n\nslack [global options] auth revoke [--test arg]\n\nslack [global options] auth test\n\nCOMMANDS\nrevoke - Revokes a token.\ntest   - Checks authentication & identity.\n```"
    )
  end

  it 'does not inject ;' do
    expect(message: "#{SlackRubyBot.config.user} help auth ; ls").to respond_with_slack_message(
      "```\nerror: Unknown command ';'.  Use 'slack help' for a list of commands.\n```"
    )
  end
end
