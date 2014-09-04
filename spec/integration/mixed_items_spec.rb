require_relative '../spec_helper'
require_relative '../../sales_taxes_app/application'

describe 'SalesTaxes application happy cases', :integration do

  it 'generates taxes summary with both gst and import taxation when receipt with mixed items' do
=begin
    Given keywords for items classification are set with
      | food | medical | books | imported |
      | abc  | ...     | ....  | abc      |
    And the following products exist
      | ... |
    When I run the tool with the following receipt
      | abc       | ... |
    Then I should see the following report with "1.23" as total and "13.34" as taxes
      | abc |
=end

    classification_keywords = {
      food: 'pasta, gnocchi',
      books: 'book, little red riding hood',
      medical: 'scalpel, malox,methadone',
      imported: 'imported, turkey'
    }
    IntegrationHelper.set_classification_keywords classification_keywords
    items = [
      {quantity: 1, product: 'imported pasta', price: '12.49', full_price: '13.14'},
      {quantity: 2, product: 'some Italian gnocchi', price: '2.76'},
      {quantity: 3, product: 'I feel Malox', price: '5.63'},
      {quantity: 4, product: 'Let us read a book', price: '12.36'},
      {quantity: 5, product: 'something else', price: '22.77', full_price: '25.07'},
      {quantity: 2, product: 'Fancy imported Italian stuff', price: '10.55', full_price: '12.15'}
    ]
    input_file = IntegrationHelper.create_receipt_file items

    output_lines = IntegrationHelper.run_application_with input_file: input_file.path

    expected_output = IntegrationHelper.build_console_output items

    expect(output_lines).to eql expected_output
  end
end