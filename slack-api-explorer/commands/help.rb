module SlackApiExplorer
  module Commands
    class Help < SlackRubyBot::Commands::Base
      def self.help_for(expression = nil)
        @help ||= {}
        expression = Shellwords.join(['slack', 'help', Shellwords.parse(expression).compact].flatten)
        result, _ = Open3.capture2e(expression)
        @help[expression] ||= "```\n" + result.gsub(/^(    )/, '').strip + "\n```"
      end

      def self.commands
        @commands ||= begin
          commands = `slack help`.gsub(/.*?(COMMANDS)/m, '').gsub(/^(    )/, '')

          all = {}
          commands.split("\n").each { |command|
            next if command.strip.blank?

            parts = command.split(/[\_\s]/, 2)
            all[parts[0]] ||= []
            all[parts[0]] << parts[1]
          }

          all.keys.map do |group|
            "#{group}#{all[group].first}"
          end
        end
      end

      HELP = <<~EOS.freeze
        I am your friendly Api Explorer, here to help.

        ```
        General
        -------

        help                                      - Get this helpful message.

        Commands
        --------
        #{commands.join("\n")}

        Not sure where to start? Try "auth test", then invite the bot to #general and DM it "chat postMessage --as_user=true --text='Hello World' --channel=#general".

        Most commands contain subcommands, try "help <command>" (eg. "help api") to get a list of subcommands.
        ```
      EOS

      def self.call(client, data, match)
        expression = match['expression'] if match.names.include?('expression')
        if expression && !expression.empty?
          client.say(channel: data.channel, text: help_for(expression))
        else
          client.say(channel: data.channel, text: [HELP, INFO].join("\n"))
        end
        logger.info "HELP: #{client.owner}, user=#{data.user}, for=#{expression || 'help'}"
      end
    end
  end
end
