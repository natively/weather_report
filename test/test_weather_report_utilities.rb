require 'minitest/autorun'
require_relative '../lib/weather_report.rb'

class WeatherReportUtilitiesTest < ::Minitest::Test
  #
  # Test WeatherReport::Utilities#convert_k_to_f
  #
  def test_k_to_f
    assert_nil(::WeatherReport::Utilities.convert_k_to_f(k: nil))

    # freezing...
    assert_equal(::WeatherReport::Utilities.convert_k_to_f(k: 273), 31.73)

    # boiling...
    assert_equal(::WeatherReport::Utilities.convert_k_to_f(k: 373), 211.73)
  end

  #
  # Test WeatherReport::Utilities#parse_owm_response
  #
  def test_parse_owm_response
    owm_response = {
      "coord"=>{"lon"=>-84.12, "lat"=>35.86},
      "weather"=>[{"id"=>802, "main"=>"Clouds", "description"=>"scattered clouds", "icon"=>"03n"}],
      "base"=>"stations",
      "main"=>{"temp"=>298.65, "pressure"=>1018, "humidity"=>65, "temp_min"=>298.15, "temp_max"=>299.15},
      "visibility"=>16093,
      "wind"=>{"speed"=>1.16, "deg"=>209.501},
      "clouds"=>{"all"=>40},
      "dt"=>1499737980,
      "sys"=>{"type"=>1, "id"=>2519, "message"=>0.0055, "country"=>"US", "sunrise"=>1499768961, "sunset"=>1499820869},
      "id"=>0,
      "name"=>"Knoxville",
      "cod"=>200
    }

    assert_equal(::WeatherReport::Utilities.parse_owm_response(response_body: owm_response, zip_code: 37922), {
      weather: 'scattered clouds',
      zip_code: 37922,
      pressure: 1018,
      temperature: 77.9,
      wind_speed: 1.16,
      wind_direction: 209.501,
      humidity: 65,
      time: 1499737980
    })
  end

  #
  # Test WeatherReport::Utilities#weather_description_from_owm_response
  #
  def test_weather_description_from_owm_response
    owm_response = {
      "weather"=>[
        {"id"=>802, "main"=>"Clouds", "description"=>"scattered clouds", "icon"=>"03n"},
        {"id"=>802, "main"=>"Clouds", "description"=>"sunny", "icon"=>"03n"},
        {"id"=>802, "main"=>"Clouds", "description"=>"", "icon"=>"03n"},
        {"id"=>802, "main"=>"Clouds", "icon"=>"03n"},
        nil
      ],
    }

    assert_equal(WeatherReport::Utilities.weather_description_from_owm_response(response_body: owm_response), 'scattered clouds, sunny')
  end
end
