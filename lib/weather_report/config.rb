module WeatherReport
  class Config
    CONFIG_PATH = File.expand_path('../../../config/config.yaml'.freeze, __FILE__).freeze

    class << self
      #
      # Load the config/config.yaml file and environment.
      #
      def load_from_file(config_path: CONFIG_PATH)
        config = ::YAML.load_file(config_path)
        config['owm_key'] ||= ENV.fetch('OWM_KEY')

        config
      end
    end
  end
end

