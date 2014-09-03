module SalesTaxesApp
  class Configuration
    def self.product_keywords_yml_file
      @@product_keywords_yml_file ||= File.expand_path('../resources/product_keywords.yml', File.dirname(__FILE__))
    end

    private

    def self.product_keywords_yml_file=(file_path)
      @@product_keywords_yml_file = file_path
    end
  end
end