require 'open3'

module SlackMetabot
  module Commands
    class Slack < SlackRubyBot::Commands::Base
      match(/^(?<bot>\w*)\s+(?<expression>.+)/)

      def self.call(client, data, match)
        _stdin, stdout, stderr, _wait_thr = Open3.popen3(* [
          'slack',
          '--slack-api-token',
          client.team.token,
          match['expression'].split(' ')
        ].flatten)

        output = stdout.gets(nil).try(:strip)
        err = stderr.gets(nil).try(:strip)

        send_message client, data.channel, "```\n#{err || output}```"
      ensure
        stderr.close if stderr
        stdout.close if stdout
      end
    end
  end
end
