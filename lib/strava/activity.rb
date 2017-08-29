require 'time'

# Strava activity model
class Activity
  attr_accessor :date, :distance_km, :elapsed_time_min, :avg_speed

  # Initialize an activity from the raw API json from Strava
  #
  # +raw_activity+ [Hash]
  def initialize(raw_activity)
    @date = Time.parse(raw_activity.start_date_local)
    @distance_km = (raw_activity.distance / 1000.0).round(3)
    @elapsed_time_min = (raw_activity.elapsed_time / 60.0).round(2)
    elapsed_time_hour = (raw_activity.elapsed_time / 3600.0)
    @avg_speed = (distance_km / elapsed_time_hour).round(2)
  end

  def human_date
    date.strftime("%d %h %Y")
  end

  def human_distance_km
    "#{distance_km} km"
  end

  def human_elapsed_time
    "#{elapsed_time_min} min"
  end

  def human_avg_speed
    "#{avg_speed} km/h"
  end
end
