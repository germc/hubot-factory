module HubotFactory
  class Adapters
    attr_writer :adapters, :adapters_file

    def self.adapters
      @adapters ||= (File.exists?(adapters_file) && YAML.load_file(adapters_file)) || {}
    end

    def self.adapters_file
      @adapters_file ||= File.expand_path("../../../config/adapters.yml", __FILE__)
    end
  end
end
