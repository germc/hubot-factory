module HubotFactory
  class Settings
    attr_writer :secrets, :secrets_file

    def self.secrets
      @secrets ||= (File.exists?(secrets_file) && YAML.load_file(secrets_file)) || {}
    end

    def self.secrets_file
      @secrets_file ||= File.expand_path("../../../config/config.yml", __FILE__)
    end
  end
end
