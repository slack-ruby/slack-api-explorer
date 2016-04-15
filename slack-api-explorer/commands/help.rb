module SlackApiExplorer
  module Commands
    class Help < SlackRubyBot::Commands::Base
      def self.help_for(expression = nil)
        @help ||= {}
        @help[expression] ||= '```' + `slack help #{expression}`.gsub(/^(    )/, '') + '```'
      end

      HELP = <<-EOS
I am your friendly Api Explorer, here to help.

```
General
-------

help       - get this helpful message

Commands
--------
#{`slack help`.gsub(/.*?(COMMANDS)/m, '').gsub(/^(    )/, '')}
Most commands contain subcommands, try "help <command>" (eg. "help api") to get a list of subcommands.
```
        EOS

      def self.call(client, data, match)
        expression = match['expression'] if match.names.include?('expression')
        help = expression && expression.length > 0 ? help_for(expression) : HELP
        client.say(channel: data.channel, text: [help, SlackApiExplorer::INFO].join("\n"))
        client.say(channel: data.channel, gif: 'help')
        logger.info "HELP: #{client.owner} - #{data.user}"
      end
    end
  end
end
