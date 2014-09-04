require_relative '../spec_helper'
require_relative '../../sales_taxes_app/application'

describe 'SalesTaxes application happy cases', :integration do

  it 'generates the taxes summary when receipt with taxable items' do
=begin
    Given no keywords for items classification are set
    And the following products exist
      | ... |
    When I run the tool with the following receipt
      | book      | ... |
      | Chocolate | ... |
    Then I should see the following report with "1.23" as total and "13.34" as taxes
      | book      | ... |
      | Chocolate | ... |
=end

    #classification_keywords = {}
    items = [
      {quantity: 1, product: 'book', price: '12.49', full_price: '13.74'},
      {quantity: 1, product: 'chocolate bar', price: '0.85', full_price: '0.95'}
    ]
    input_file = IntegrationHelper.create_receipt_file items

    output_lines = IntegrationHelper.run_application_with input_file: input_file.path

    expected_output = IntegrationHelper.build_console_output items

    expect(output_lines).to eql expected_output
  end
end