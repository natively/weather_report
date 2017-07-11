module WeatherReport
  class Database
    DATABASE_NAME = 'weather_report.db'.freeze

    class << self
      def db(database_name: self::DATABASE_NAME)
        db = ::SQLite3::Database.new(database_name)

        # create the table if none exists
        db.execute <<-SQL
          CREATE TABLE IF NOT EXISTS reports (
            weather TEXT,
            zip_code INT,
            pressure REAL,
            temperature REAL,
            wind_speed REAL,
            wind_direction REAL,
            humidity REAL,
            time BIGINT
          );
        SQL

        db
      end

      def import(report_blob:, database_name: self::DATABASE_NAME)
        db = self.db(database_name: database_name)

        puts "Inserting report: #{report_blob}"

        db.execute(
          "INSERT INTO reports (weather, zip_code, pressure, temperature, wind_speed, wind_direction, humidity, time) VALUES (?, ?, ?, ?, ?, ?, ?, ?);",
          [
            report_blob[:weather],
            report_blob[:zip_code],
            report_blob[:pressure],
            report_blob[:temperature],
            report_blob[:wind_speed],
            report_blob[:wind_direction],
            report_blob[:humidity],
            report_blob[:time]
          ]
        )

        db
      end
    end
  end
end
