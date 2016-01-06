require 'open3'

module SlackMetabot
  module Commands
    class Slack < SlackRubyBot::Commands::Base
      match(/^(?<bot>\w*)\s+(?<expression>.+)/)

      def self.call(client, data, match)
        expression = match['expression']
        expression.gsub! '—', '--'
        logger.info "SLACK: #{client.team} - #{expression}"
        args, pipe = Shellwords.parse(expression)
        execute(client, args) do |output, error|
          if error
            send_message client, data.channel, "```\n#{error}```"
          else
            output = pipe ? JsonPath.on(output, pipe) : JSON.parse(output)
            output = JSON.pretty_generate(output)
            send_message client, data.channel, "```\n#{output}```"
          end
        end
      rescue SyntaxError => e
        send_message_with_gif client, data.channel, e.message, 'error'
      end

      def self.execute(client, args)
        Open3.popen3(* [
          'slack',
          '--slack-api-token',
          client.team.token,
          args
        ].flatten) do |_, stdout, stderr, _|
          yield stdout.gets.try(:strip), stderr.gets.try(:strip)
        end
      end
    end
  end
end
