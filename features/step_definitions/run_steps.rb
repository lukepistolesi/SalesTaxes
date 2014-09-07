When(/^I run the app with the following items$/) do |table|
  items = table.hashes.inject("Quantity, Product, Price\n") do |buffer, row|
    buffer.concat row.values.join(', ')
    buffer.concat "\n"
  end
  @input_file.write items
  @input_file.close
  @console_output = `#{File.expand_path './extract_taxes.sh'} #{@input_file.path}`.split "\n"
end
