require 'easy_app_helper'
require 'terminal-table'
require 'strava/api/v3'
require 'vcr'
require 'time'

# Method access to Hash content
require 'hashie'
class Hash; include Hashie::Extensions::MethodAccess; end

# Configure HTTP records
VCR.configure do |config|
  config.cassette_library_dir = "#{File.expand_path('~')}/.strava"
  config.hook_into :webmock
end

module Strava
  class App
    include EasyAppHelper

    NAME = 'Strava Dashboard'
    DESCRIPTION = 'Fetchs data from strava to report what you have done'

    attr_accessor :client, :types, :fields
    def initialize
      config.config_file_base_name = 'strava'
      config.describes_application app_name: NAME,
                                   app_version: Strava::VERSION,
                                   app_description: DESCRIPTION

      config.add_command_line_section('Strava options') do |slop|
        slop.on :strava_access_token, 'Strava access token', argument: true, as: String
        slop.on :activity, 'Display this activity type only (Run, Ride, Swim)', argument: true
      end

      if config[:help]
        puts config.command_line_help
        exit 0
      end

      if config[:activity]
        @types = [config[:activity]]
      else
        @types = %w(Run Ride Swim)
      end
      @fields = ["Start date", "Distance", "Elapsed time", "Avg speed"]
    end

    def configure_api_client
      @client = Strava::Api::V3::Client.new(access_token: config[:strava_access_token])
    end

    def run
      configure_api_client

      activities = []

      VCR.use_cassette("activities", record: :new_episodes) do
        page = 0
        per_page = 100
        while activities.count == page*per_page
          page +=1
          activities += client.list_athlete_activities(per_page: per_page,page: page)
        end
      end

      for type in types
        rows = []
        month = -1
        activities.select { |activity| activity.type == type }.each do |activity|
          date = Time.parse(activity.start_date_local)
          current_month = date.month
          distance_km = (activity.distance/1000.0).round(3)
          elapsed_time_min = (activity.elapsed_time/60.0).round(2)
          elapsed_time_hour = (activity.elapsed_time/3600.0)
          avg_speed = (distance_km/elapsed_time_hour).round(2)
          if current_month != month && month != -1
            rows << :separator
          end
          month = current_month
          rows << [date , "#{distance_km} km", "#{elapsed_time_min} min", "#{avg_speed} km/h"]
        end

        table = Terminal::Table.new :title => type, :headings => fields, :rows => rows

        if rows.empty?
          puts "No activity found. Go out and start #{type}ing!"
        else
          puts table
        end
        puts "\n"
      end
    end
  end
end

