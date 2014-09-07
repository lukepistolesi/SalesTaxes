require 'singleton'
require 'yaml'

module SalesTaxesApp
  class Configuration
    include Singleton

    def product_keywords_yml_file
      @product_keywords_yml_file ||= './resources/product_keywords.yml'
    end

    def settings
      @settings ||= load_yaml
    end

    private

    def product_keywords_yml_file=(file_path)
      @product_keywords_yml_file = file_path
      @settings = nil
    end

    def load_yaml
      YAML.load File.new(File.expand_path product_keywords_yml_file)
    end
  end
end