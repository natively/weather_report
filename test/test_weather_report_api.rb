require 'minitest/autorun'
require_relative '../lib/weather_report.rb'

class WeatherReportApiTest < ::Minitest::Test
  def test_requires_owm_key
    error = assert_raises(::RuntimeError) { ::WeatherReport::Api.current_weather_for_zip_code(zip_code: nil, owm_key: '') }
    assert_equal('OpenWeatherMap API key is not defined.', error.message)

    error = assert_raises(::RuntimeError) { ::WeatherReport::Api.current_weather_for_zip_code(zip_code: nil, owm_key: nil) }
    assert_equal('OpenWeatherMap API key is not defined.', error.message)
  end

  def test_requires_zip_code
    error = assert_raises(::RuntimeError) { ::WeatherReport::Api.current_weather_for_zip_code(zip_code: nil, owm_key: 'defined') }
    assert_equal('Zip Code missing.', error.message)

    error = assert_raises(::RuntimeError) { ::WeatherReport::Api.current_weather_for_zip_code(zip_code: '', owm_key: 'defined') }
    assert_equal('Zip Code missing.', error.message)
  end
end
