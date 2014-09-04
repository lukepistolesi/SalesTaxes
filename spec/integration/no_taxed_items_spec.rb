require_relative '../spec_helper'
require_relative '../../sales_taxes_app/application'

describe 'SalesTaxes application happy cases', :integration do

  it 'generates the taxes summary when receipt without taxable items' do
=begin
    Given keywords for items classification are set with
      | food | medical | books |
      | ...  | ...     | ....  |
    And the following products exist
      | ... |
    When I run the extration tool with the following receipt
      | book      | ... |
      | Chocolate | ... |
    Then I should see an empty report with "1.23" as total and "0.0" as taxes
=end

    classification_keywords = {
      food: 'chocolate, pasta',
      books: 'book, pinocchio',
      medical: 'ointment, aspirin'
    }
    IntegrationHelper.set_classification_keywords classification_keywords
    items = [
      {quantity: 1, product: 'book', price: 12.49, taxes: 0.0},
      {quantity: 2, product: 'aspirin', price: 2.76, taxes: 0.0},
      {quantity: 1, product: 'chocolate bar', price: 0.85, taxes: 0.0}
    ]
    input_file = IntegrationHelper.create_receipt_file items

    output_lines = IntegrationHelper.run_application_with input_file: input_file.path

    total = items.inject(0){ |sum, item| sum += item[:price]; sum }
    expected_summary = { taxes: '0.0', total: total.round(2).to_s }
    expected_output = IntegrationHelper.build_console_output items, expected_summary

    expect(output_lines).to eql expected_output
  end
end