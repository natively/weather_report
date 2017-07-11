Weather Report
==============
![image of weather report](https://raw.githubusercontent.com/natively/weather_report/master/wr.jpg)

Pulls current weather reports from OpenWeatherMap and saves them to a local SQLite3 database `weather_report.db`

to get started:
`./bin/bundle install`

to run the tests:
`./bin/rake test`

to start the weather reporter:
`./bin/rake weather_report:start OWM_KEY=<your_api_key>`
