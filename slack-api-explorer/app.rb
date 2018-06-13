module SlackApiExplorer
  class App < SlackRubyBotServer::App
    include Celluloid

    def prepare!
      super
      purge_inactive_teams!
    end

    def after_start!
      every 60 * 60 do
        ping_teams!
      end
    end

    private

    def purge_inactive_teams!
      Team.purge!
    end

    def ping_teams!
      Team.active.each do |team|
        begin
          ping = team.ping!
          next if ping[:presence].online
          logger.warn "DOWN: #{team}"
          after 60 do
            ping = team.ping!
            unless ping[:presence].online
              logger.info "RESTART: #{team}"
              SlackApiExplorer::Service.instance.start!(team)
            end
          end
        rescue StandardError => e
          logger.warn "Error pinging team #{team}, #{e.message}."
        end
      end
    end
  end
end
