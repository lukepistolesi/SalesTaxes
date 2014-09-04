require_relative '../spec_helper'
require_relative '../../sales_taxes_app/application'

module SalesTaxesApp

  describe Application do

    let(:cmd_line_args) { [] }

    describe :run do
      let(:parsed_opts) { {} }

      before :each do
        allow(Application).to receive(:parse_command_line_opts).and_return parsed_opts
        allow(ReceiptFactory).to receive :from_csv
        allow(TaxesCalculator).to receive :compute_taxes!
        allow(TaxesCalculator).to receive :compute_total_price!
        allow(ReceiptRenderer).to receive :render_receipt
      end

      subject { Application.run cmd_line_args}

      it 'parses the command line options' do
        expect(Application).to receive(:parse_command_line_opts).with cmd_line_args
        subject
      end

      it 'allocates a new receipt from the input file' do
        expected_input_file = 'just a file'
        parsed_opts[:input_file] = expected_input_file
        expect(ReceiptFactory).to receive(:from_csv).with expected_input_file

        subject
      end

      it 'computes the taxes for the created receipt' do
        new_receipt = 'The new receipt'
        allow(ReceiptFactory).to receive(:from_csv).and_return new_receipt
        expect(TaxesCalculator).to receive(:compute_taxes!).with new_receipt

        subject
      end

      it 'computes the total for the created receipt' do
        new_receipt = 'The new receipt'
        allow(ReceiptFactory).to receive(:from_csv).and_return new_receipt
        expect(TaxesCalculator).to receive(:compute_total_price!).with new_receipt

        subject
      end

      it 'renders the receipt' do
        new_receipt = 'The new receipt'
        allow(ReceiptFactory).to receive(:from_csv).and_return new_receipt
        expect(ReceiptRenderer).to receive(:render_receipt).with new_receipt

        subject
      end
    end

    describe :parse_command_line_opts do

      subject { Application.parse_command_line_opts cmd_line_args}

      it 'returns the input file path' do
        expected_file_name = 'Input File Name'
        cmd_line_args << expected_file_name
        expect(subject).to eql({input_file: expected_file_name})
      end

      it 'raises exception when no input file path' do
        expect{subject}.to raise_error 'Wrong number of arguments'
      end

      it 'raises exception when too many params are provided' do
        cmd_line_args.concat ['file1', 'file2']
        expect{subject}.to raise_error 'Wrong number of arguments'
      end
    end
  end
end