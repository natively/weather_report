module WeatherReport
  class Utilities
    class << self
      #
      # Convert Kelvin to Fahrenheit
      #
      def convert_k_to_f(k:)
        if k.nil?
          nil
        else
          calculation = ((k.to_f - 273.15) * 1.8) + 32
          ('%.2f' % calculation).to_f
        end
      end

      #
      # Database-friendly hash for insert
      #
      def parse_owm_response(response_body: {}, zip_code:)
        {
          weather: ::WeatherReport::Utilities.weather_description_from_owm_response(response_body: response_body),
          zip_code: zip_code,
          pressure: response_body.fetch('main', {})['pressure'],
          temperature: ::WeatherReport::Utilities.convert_k_to_f(k: response_body.fetch('main', {})['temp']),
          wind_speed: response_body.fetch('wind', {})['speed'],
          wind_direction: response_body.fetch('wind', {})['deg'],
          humidity: response_body.fetch('main', {})['humidity'],
          time: response_body.fetch('dt', 0)
        }
      end

      #
      # For example:
      # response_body: "weather"=>[{"id"=>802, "main"=>"Clouds", "description"=>"scattered clouds", "icon"=>"03n"}]
      # => 'scattered clouds'
      #
      def weather_description_from_owm_response(response_body: {})
        if response_body.nil?
          ''
        else
          weather_descriptions = response_body.fetch('weather', [])

          weather_descriptions = weather_descriptions.
            compact.
            map { |d| d['description'] }.
            compact

          weather_descriptions.delete('')
          weather_descriptions.join(', ')
        end
      end
    end
  end
end
