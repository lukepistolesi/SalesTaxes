require 'tempfile'

class IntegrationHelper

  def self.gst(price) self.calc_taxes price, 10.0 end

  def self.import_tax(price) self.calc_taxes price, 5.0 end

  def self.calc_taxes(price, tax_percentage)
    (price.to_f * (1.0 - 100.0/(tax_percentage.to_f + 100.0))).round 2
  end

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
      SalesTaxesApp::Application.run ARGV
    ensure
      $stdout = old_stdout
    end
    new_stdout.string.split "\n"
  end

  def self.build_console_output(items, summary)
    output_string = items.inject('') do |buffer, item|
      buffer.concat "#{item[:quantity]}, #{item[:product]}, #{item[:price]}\n"
    end
    output_string.concat "Sales Taxes: #{summary[:taxes]}\nTotal: #{summary[:total]}"
    output_string.split "\n"
  end
end