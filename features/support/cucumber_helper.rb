class CucumberHelper

  def self.classification_keywords=(keywords_hash)
    custom_keywords = { keywords: { food: '', books: '', medical: '', imported: '' }.merge(keywords_hash) }
    yaml_file = File.expand_path('./../../resources/product_keywords.yml', File.dirname(__FILE__))
    (file = File.new(yaml_file, 'w')).write YAML.dump(custom_keywords)
    file.close
  end

  def self.classification_keywords
    yaml_file_path = File.expand_path('./../../resources/product_keywords.yml', File.dirname(__FILE__))
    file = File.new yaml_file_path
    keywords = YAML.load(file)[:keywords]
    file.close
    keywords
  end
end