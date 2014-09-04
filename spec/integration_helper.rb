require 'tempfile'

class IntegrationHelper

  def self.create_receipt_file(items)
    file = Tempfile.new 'foo.csv'
    file.write "Quantity, Product, Price\n"
    items.each { |item| file.write "#{item[:quantity]}, #{item[:product]}, #{item[:price]}\n" }
    file.close
    file
  end

  def self.run_application_with(input_hash)
    old_stdout = $stdout
    new_stdout = StringIO.new
    $stdout = new_stdout
    begin
      if input_hash[:output_file]
        SalesTaxesApp::Application.run [input_hash[:input_file], '-o', input_hash[:output_file]]
      else
        SalesTaxesApp::Application.run [input_hash[:input_file]]
      end
    ensure
      $stdout = old_stdout
    end
    new_stdout.string.split "\n"
  end

  def self.build_console_output(items)
    total = total_taxes = 0.0
    output_string = items.inject('') do |buffer, item|
      total += price = (item[:full_price] || item[:price]).to_f
      total_taxes += item[:full_price].nil? ? 0.0 : (item[:full_price].to_f - item[:price].to_f)
      buffer.concat "#{item[:quantity]}, #{item[:product]}, #{'%.2f' % price}\n"
    end
    output_string.concat "Sales Taxes: #{'%.2f' % total_taxes}\nTotal: #{'%.2f' % total}"
    output_string.split "\n"
  end

  def self.set_classification_keywords(keywords)
    custom_keywords = { keywords: keywords }
    test_yaml_file = File.expand_path('./product_keywords.yml', File.dirname(__FILE__))
    (file = File.new(test_yaml_file, 'w')).write YAML.dump(custom_keywords)
    file.close
    SalesTaxesApp::Configuration.instance.send :product_keywords_yml_file=, test_yaml_file
  end
end