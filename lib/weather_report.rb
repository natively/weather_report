require 'faraday'
require 'json'
require 'rufus-scheduler'
require 'sqlite3'
require 'yaml'

require_relative 'weather_report/config.rb'
require_relative 'weather_report/database.rb'
require_relative 'weather_report/api.rb'
require_relative 'weather_report/utilities.rb'

module WeatherReport
  extend self

  def start
    config = ::WeatherReport::Config.load_from_file

    self.schedule(config: config)
  end

  def schedule(config: {})
    scheduler = ::Rufus::Scheduler.new

    zip_codes = config['zip_codes']
    zip_codes.each do |zip_code, interval|
      puts "Scheduling Zip Code #{zip_code} every #{interval} seconds..."

      scheduler.every("#{interval.to_i}s") do
        self.import_from_zip_code(zip_code: zip_code, owm_key: config['owm_key'])
      end
    end

    scheduler.join
  end

  def import_from_zip_code(zip_code:, owm_key:)
    puts "Importing for zip_code: #{zip_code}..."

    api_response = ::WeatherReport::Api.current_weather_for_zip_code(zip_code: zip_code, owm_key: owm_key)

    report = ::WeatherReport::Utilities.parse_owm_response(response_body: api_response, zip_code: zip_code)

    ::WeatherReport::Database.import(report_blob: report)
  end
end

