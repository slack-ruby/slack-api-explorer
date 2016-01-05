ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
Bundler.require :default, ENV['RACK_ENV']

Dir[File.expand_path('../config/initializers', __FILE__) + '/**/*.rb'].each do |file|
  require file
end

Mongoid.load! File.expand_path('../config/mongoid.yml', __FILE__), ENV['RACK_ENV']

require 'faye/websocket'
require 'slack-ruby-bot'
require 'slack-metabot/error'
require 'slack-metabot/version'
require 'slack-metabot/info'
require 'slack-metabot/models'
require 'slack-metabot/api'
require 'slack-metabot/app'
require 'slack-metabot/server'
require 'slack-metabot/service'
require 'slack-metabot/commands'
