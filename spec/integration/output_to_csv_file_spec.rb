require_relative '../spec_helper'
require_relative '../../sales_taxes_app/application'

describe 'SalesTaxes application saves result in CSV file', :integration do

  it 'generates the taxes summary into the given CSV' do
=begin
    Given keywords for items classification are set with
      | food | medical | books |
      | ...  | ...     | ....  |
    And the following products exist
      | ... |
    When I run the tool with output file "abc" with the following receipt
      | book      | ... |
      | Chocolate | ... |
    Then I should see an empty report with "1.23" as total and "0.0" as taxes
=end

    classification_keywords = {
      food: 'chocolate, pasta',
      books: 'book, pinocchio',
      medical: 'ointment, aspirin',
      imported: ''
    }
    IntegrationHelper.set_classification_keywords classification_keywords
    items = [
      {quantity: 1, product: 'book', price: '12.49'},
      {quantity: 2, product: 'aspirin', price: '2.76'},
      {quantity: 1, product: 'chocolate bar', price: '0.85'}
    ]
    input_file = IntegrationHelper.create_receipt_file items
    output_file =  Tempfile.new 'output.csv'

    IntegrationHelper.run_application_with input_file: input_file.path, output_file: output_file.path

    expected_output = IntegrationHelper.build_console_output items

    expect(output_file.read.split("\n")).to eql expected_output
  end
end