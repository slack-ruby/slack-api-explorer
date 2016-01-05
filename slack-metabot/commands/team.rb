module SlackMetabot
  module Commands
    class Team < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        send_message_with_gif client, data.channel, "Team _#{client.team.name}_.", 'team'
        logger.info "TEAM: #{client.team} - #{data.user}"
      end
    end
  end
end
