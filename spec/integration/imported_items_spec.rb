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
    When I run the extration tool with the following receipt
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
      {quantity: 1, product: 'imported nuts', price: 12.49, taxes: IntegrationHelper.import_tax(12.49)},
      {quantity: 2, product: 'imported nutty stuff', price: 2.76, taxes: IntegrationHelper.import_tax(2.76)}
    ]
    input_file = IntegrationHelper.create_receipt_file items

    output_lines = IntegrationHelper.run_application_with input_file: input_file.path

    total = items.inject(0){ |sum, item| sum += item[:price]; sum }
    taxes = items.inject(0){ |sum, item| sum += item[:taxes].to_f; sum }
    taxes = (taxes * 20).round / 20.0
    expected_summary = { taxes: taxes.round(2).to_s, total: total.round(2).to_s }
    expected_output = IntegrationHelper.build_console_output items, expected_summary

    expect(output_lines).to eql expected_output
  end
end