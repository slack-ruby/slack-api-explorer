require 'open3'

module SlackApiExplorer
  module Commands
    class Slack < SlackRubyBot::Commands::Base
      match(/^(?<bot>[[:alnum:][:punct:]@<>]*)\s+(?<expression>.+)/)

      def self.call(client, data, match)
        expression = match['expression']
        expression = ::Slack::Messages::Formatting.unescape(expression)
        expression.gsub! '—', '--'
        logger.info "SLACK: #{client.owner}, cmd=#{expression}"
        args, pipe = Shellwords.parse(expression)
        cmd = Shellwords.shelljoin(['slack', '--slack-api-token', client.owner.token, args].flatten)
        output, error, _ = Open3.capture3(cmd)
        error&.strip!
        output&.strip!
        if error && !error.blank?
          client.say(channel: data.channel, text: "```\n#{error}```")
        else
          output = pipe ? JsonPath.on(output, pipe) : JSON.parse(output)
          output = JSON.pretty_generate(output)
          client.say(channel: data.channel, text: "```\n#{output}```")
        end
      rescue SyntaxError => e
        client.say(channel: data.channel, text: e.message)
      end
    end
  end
end
