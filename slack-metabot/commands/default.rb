module SlackMetabot
  module Commands
    class Default < SlackRubyBot::Commands::Base
      match(/^(?<bot>\w*)$/)

      def self.call(client, data, _match)
        client.say(channel: data.channel, text: SlackMetabot::INFO)
        client.say(channel: data.channel, gif: 'robot')
      end
    end
  end
end
