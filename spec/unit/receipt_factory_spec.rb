require_relative '../spec_helper'
require_relative '../../sales_taxes_app/receipt_factory'
require 'csv'

module SalesTaxesApp

  describe ReceiptFactory do

    describe :from_csv do

      let(:file_path) { 'File Path' }
      let(:mocked_receipt) { double Models::Receipt }

      before :each do
        allow(mocked_receipt).to receive :items=
        allow(Models::Receipt).to receive(:new).and_return mocked_receipt
        allow(CSV).to receive :foreach
      end

      subject { ReceiptFactory.from_csv file_path }

      it 'allocates a new receipt' do
        expect(Models::Receipt).to receive :new
        subject
      end

      it 'parses the input file with headers' do
        params = { headers: true, header_converters: anything }
        expect(CSV).to receive(:foreach).with(file_path, params)
        subject
      end

      it 'creates a receipt item for one csv line' do
        qt, prod_name, price = [ '12', 'Prod Name', '12.3']
        csv_row = {'Quantity' => qt, 'Product' => prod_name, 'Price' => price}
        allow(CSV).to receive(:foreach).and_yield csv_row
        expect(Models::ReceiptItem).to receive(:new).with qt, prod_name, price.to_f

        subject
      end

      it 'raises an error when exception data manipulation' do
        allow(CSV).to receive(:foreach).and_yield({})
        expect{subject}.to raise_error
      end

      it 'assigns the created items to the receipt' do
        item = 'An Item'
        csv_row = {'Quantity' => '', 'Product' => '', 'Price' => ''}
        allow(CSV).to receive(:foreach).and_yield csv_row
        allow(Models::ReceiptItem).to receive(:new).and_return item
        expect(mocked_receipt).to receive(:items=).with [item]

        subject
      end

      it 'assigns an empty collection when no items' do
        allow(CSV).to receive(:foreach).and_return nil
        expect(mocked_receipt).to receive(:items=).with []

        subject
      end

      it 'returns the newly created receipt' do
        expect(subject).to eql mocked_receipt
      end
    end

  end
end
