require 'easy_app_helper'
require 'terminal-table'
require 'ascii_charts'
require 'strava/api/v3'
require 'vcr'

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

    attr_accessor :client, :types, :graph, :activities

    def initialize
      config.config_file_base_name = 'strava'
      config.describes_application app_name: NAME,
                                   app_version: Strava::VERSION,
                                   app_description: DESCRIPTION

      config.add_command_line_section('Strava options') do |slop|
        slop.on :strava_access_token, 'Strava access token', argument: true, as: String
        slop.on :activity, 'Display this activity type only (Run, Ride, Swim)', argument: true
        slop.on :graph, 'Display a graph instead of a table', argument: false
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
      @graph = config[:graph]
      @activities = []
    end

    def configure_api_client
      @client = Strava::Api::V3::Client.new(access_token: config[:strava_access_token])
    end

    def run
      configure_api_client

      fetch_activities_data

      for type in types

        if graph
          output_screen = build_graph_speed(type)
        else
          output_screen = build_table(type)
        end

        if output_screen.nil?
          puts "No activity found. Go out and start #{type}ing!"
        else
          puts output_screen
        end
        puts "\n"
      end
    end

    private

    def build_table(activity_type)
      fields = ["Date", "Distance", "Elapsed time", "Avg speed"]
      rows = []
      date = -1

      select_activities(activity_type).each do |raw_activity|
        activity = Activity.new(raw_activity)
        current_date = activity.date

        rows << :separator if date != -1 && current_date.month != date.month

        date = current_date
        rows << [
          activity.human_date,
          activity.human_distance_km,
          activity.human_elapsed_time,
          activity.human_avg_speed
        ]
      end

      !rows.empty? && Terminal::Table.new(
        title: activity_type,
        headings: fields,
        rows: rows
      )
    end

    def build_graph_speed(activity_type)
      graph = ''

      all = select_activities(activity_type).map do |raw_activity|
        Activity.new(raw_activity)
      end

      activities_by_year = all.group_by do |activity|
        activity.date.year
      end

      activities_by_year.each do |year, a|
        data = []

        activities_by_month = a.group_by do |activity|
          activity.date.month
        end

        activities_by_month.each do |month, activities|
          avg_speed = activities.sum(&:avg_speed) / activities.size

          data << [
            "#{month}/#{year}",
            avg_speed
          ]
        end

        data.size > 1 && graph += AsciiCharts::Cartesian.new(
          data.reverse,
          title: "#{year} - #{activity_type} avg speed",
          step_size: 0.3
        ).draw + "\n"
      end

      !graph.empty? && graph
    end

    def fetch_activities_data
      VCR.use_cassette("activities", record: :new_episodes) do
        page = 0
        per_page = 100
        while activities.count == page*per_page
          page +=1
          @activities += client.list_athlete_activities(per_page: per_page,page: page)
        end
      end
    end

    def select_activities(type)
      activities.select { |activity| activity.type == type }
    end
  end
end

