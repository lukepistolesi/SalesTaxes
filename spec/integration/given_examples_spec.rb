require_relative '../spec_helper'
require_relative '../../sales_taxes_app/application'

describe 'Examples provided as homework', :integration do

  it 'generates the taxes summary for Example 1' do
    classification_keywords = {
      food: 'chocolate',
      books: 'book',
      medical: '',
      imported: ''
    }
    IntegrationHelper.set_classification_keywords classification_keywords
    items = [
      {quantity: 1, product: 'book', price: '12.49'},
      {quantity: 1, product: 'music cd', price: '14.99', full_price: '16.49'},
      {quantity: 1, product: 'chocolate bar', price: '0.85'}
    ]
    input_file = IntegrationHelper.create_receipt_file items

    output_lines = IntegrationHelper.run_application_with input_file: input_file.path

    expected_output = IntegrationHelper.build_console_output items

    expect(output_lines).to eql expected_output
  end


  it 'generates the taxes summary for Example 2' do
    classification_keywords = {
      food: 'chocolates',
      books: '',
      medical: '',
      imported: 'imported'
    }
    IntegrationHelper.set_classification_keywords classification_keywords
    items = [
      {quantity: 1, product: 'imported box of chocolates', price: '10.00', full_price: '10.50'},
      {quantity: 1, product: 'imported bottle of perfume', price: '47.50', full_price: '54.65'}
    ]
    input_file = IntegrationHelper.create_receipt_file items

    output_lines = IntegrationHelper.run_application_with input_file: input_file.path

    expected_output = IntegrationHelper.build_console_output items

    expect(output_lines).to eql expected_output
  end


  it 'generates the taxes summary for Example 3' do
    classification_keywords = {
      food: 'chocolates',
      books: '',
      medical: 'headache',
      imported: 'imported'
    }
    IntegrationHelper.set_classification_keywords classification_keywords
    items = [
      {quantity: 1, product: 'imported bottle of perfume', price: '27.99', full_price: '32.19'},
      {quantity: 1, product: 'bottle of perfume', price: '18.99', full_price: '20.89'},
      {quantity: 1, product: 'packet of headache pills', price: '9.75', full_price: '9.75'},
      {quantity: 1, product: 'box of imported chocolates', price: '11.25', full_price: '11.85'}
    ]
    input_file = IntegrationHelper.create_receipt_file items

    output_lines = IntegrationHelper.run_application_with input_file: input_file.path

    expected_output = IntegrationHelper.build_console_output items

    expect(output_lines).to eql expected_output
  end
end