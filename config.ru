$LOAD_PATH.unshift(File.dirname(__FILE__))

ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require :default, ENV['RACK_ENV']

require 'slack-ruby-bot-server'
require 'slack-api-explorer'

NewRelic::Agent.manual_start

SlackApiExplorer::App.instance.prepare!

Thread.abort_on_exception = true

Thread.new do
  SlackRubyBotServer::Service.instance.start_from_database!
end

run Api::Middleware.instance
