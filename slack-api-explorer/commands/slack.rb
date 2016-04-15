require 'open3'

module SlackApiExplorer
  module Commands
    class Slack < SlackRubyBot::Commands::Base
      match(/^(?<bot>[[:alnum:][:punct:]@<>]*)\s+(?<expression>.+)/)

      def self.call(client, data, match)
        expression = match['expression']
        expression = ::Slack::Messages::Formatting.unescape(expression)
        expression.gsub! '—', '--'
        logger.info "SLACK: #{client.owner} - #{expression}"
        args, pipe = Shellwords.parse(expression)
        execute(client, args) do |output, error|
          if error
            client.say(channel: data.channel, text: "```\n#{error}```")
          else
            output = pipe ? JsonPath.on(output, pipe) : JSON.parse(output)
            output = JSON.pretty_generate(output)
            client.say(channel: data.channel, text: "```\n#{output}```")
          end
        end
      rescue SyntaxError => e
        client.say(channel: data.channel, text: e.message, gif: 'error')
      end

      def self.execute(client, args)
        Open3.popen3(* [
          'slack',
          '--slack-api-token',
          client.owner.token,
          args
        ].flatten) do |_, stdout, stderr, _|
          yield stdout.gets.try(:strip), stderr.gets.try(:strip)
        end
      end
    end
  end
end
