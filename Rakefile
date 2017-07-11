desc 'run tests'
task :test do
  require_relative 'test/test_weather_report_api.rb'
  require_relative 'test/test_weather_report_database.rb'
  require_relative 'test/test_weather_report_utilities.rb'
end

namespace :weather_report do
  require_relative 'lib/weather_report.rb'

  desc 'Run continuously, once every reporting_interval as defined in config.yaml'
  task :start do
    trap('SIGINT') { exit } # ctrl c to quit

    ::WeatherReport.start
  end
end

