module SlackApiExplorer
  module Commands
    class Default < SlackRubyBot::Commands::Base
      match(/^(?<bot>\w*)$/)

      def self.call(client, data, _match)
        client.say(channel: data.channel, text: SlackApiExplorer::INFO)
      end
    end
  end
end
