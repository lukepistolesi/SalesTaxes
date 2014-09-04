require_relative '../spec_helper'
require_relative '../../sales_taxes_app/application'

describe 'SalesTaxes application happy cases', :integration do

  it 'generates the taxes summary with import taxation when receipt with imported items' do
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
      food: 'nuts, nutty', books: '', medical: '',
      imported: 'imported'
    }
    IntegrationHelper.set_classification_keywords classification_keywords
    items = [
      {quantity: 1, product: 'imported nuts', price: '12.49', full_price: '13.14'},
      {quantity: 2, product: 'imported nutty stuff', price: '2.76', full_price: '2.91'}
    ]
    input_file = IntegrationHelper.create_receipt_file items

    output_lines = IntegrationHelper.run_application_with input_file: input_file.path

    expected_output = IntegrationHelper.build_console_output items

    expect(output_lines).to eql expected_output
  end
end