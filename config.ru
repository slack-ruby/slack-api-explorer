$LOAD_PATH.unshift(File.dirname(__FILE__))

ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require :default, ENV['RACK_ENV']

require 'slack-ruby-bot-server'
require 'slack-api-explorer'

SlackApiExplorer::App.instance.prepare!

Thread.abort_on_exception = true

Thread.new do
  SlackApiExplorer::Service.instance.start_from_database!
  SlackApiExplorer::App.instance.after_start!
end

run Api::Middleware.instance
