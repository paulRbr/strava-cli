require 'vcr'

# Configure HTTP cache
VCR.configure do |config|
  config.cassette_library_dir = "#{File.expand_path('~')}/.#{Strava::BASE_NAME}"
  config.hook_into :webmock
  config.ignore_request do |request|
    request.method != :get
  end

end
