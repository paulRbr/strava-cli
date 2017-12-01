$LOAD_PATH.unshift(File.dirname(__FILE__))

# Method access to Hash content
require 'hashie'
class Hash; include Hashie::Extensions::MethodAccess; end

module Strava
  BASE_NAME = 'strava'.freeze
end

require 'strava/cache'
require 'strava/version'
require 'strava/activity'
require 'strava/app'
