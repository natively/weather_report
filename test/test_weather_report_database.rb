require 'minitest/autorun'
require_relative '../lib/weather_report.rb'

class WeatherReportDatabaseTest < ::Minitest::Test
  DATABASE_NAME = 'test.db'.freeze

  #
  # Utility Methods
  #
  def teardown
    ::SQLite3::Database.new(self.class::DATABASE_NAME).execute('DROP TABLE IF EXISTS reports;')
  end

  #
  # Create a table if none exists when invoking the database class
  #
  def test_db_creates_table
    db = ::SQLite3::Database.new(self.class::DATABASE_NAME)
    assert_equal(db.table_info('reports'), [])

    db = ::WeatherReport::Database.db(database_name: self.class::DATABASE_NAME)
    assert !db.table_info('reports').empty?
  end

  #
  # Insert the report into the reports table
  #
  def test_import_creates_row
    db = ::WeatherReport::Database.db(database_name: self.class::DATABASE_NAME)
    report_blob = {
      weather: 'scattered clouds',
      zip_code: 37922,
      pressure: 1018,
      temperature: 77.9,
      wind_speed: 1.16,
      wind_direction: 209.501,
      humidity: 65,
      time: 1499737980
    }
    
    report_count = db.execute('SELECT COUNT(*) FROM reports;')
    assert_equal(report_count, [[0]])

    ::WeatherReport::Database.import(report_blob: report_blob, database_name: self.class::DATABASE_NAME)
    report_count = db.execute('SELECT COUNT(*) FROM reports;')
    report_row = db.execute('SELECT * FROM reports;')
    assert_equal([[1]], report_count)
    assert_equal([["scattered clouds", 37922, 1018.0, 77.9, 1.16, 209.501, 65.0, 1499737980]], report_row)
  end
end

