module SlackApiExplorer
  class App < SlackRubyBotServer::App
    def prepare!
      super
      purge_inactive_teams!
    end

    private

    def purge_inactive_teams!
      Team.purge!
    end
  end
end
