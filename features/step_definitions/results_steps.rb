Then(/^I should see a receipt with total "(.*?)", taxes "(.*?)" and items$/) do |total, total_taxes, table|
  total = total.to_f
  total_taxes = total_taxes.to_f
  receipt_lines = table.hashes.inject('') do |buffer, row|
    buffer.concat "#{row['Quantity']}, #{row['Product Name']}, #{'%.2f' % row['Price']}\n"
  end
  receipt = receipt_lines.concat "Sales Taxes: #{'%.2f' % total_taxes}\nTotal: #{'%.2f' % total}"
  expect(@console_output).to eql receipt.split("\n")
end
