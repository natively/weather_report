module WeatherReport
  class Api
    API_BASE_URI = 'http://api.openweathermap.org/data/2.5/weather'

    class << self
      def connection
        ::Faraday.new(url: self::API_BASE_URI)
      end

      def current_weather_for_zip_code(zip_code:, owm_key:)
        if owm_key.nil? || owm_key.empty?
          raise 'OpenWeatherMap API key is not defined.'
        end

        if zip_code.nil? || zip_code.to_s.empty?
          raise 'Zip Code missing.'
        end

        response = connection.get do |request|
          request.params['APPID'] = owm_key
          request.params['zip'] = zip_code
        end

        ::JSON.parse(response.body.strip)
      end
    end
  end
end
