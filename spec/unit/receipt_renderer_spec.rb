require_relative '../spec_helper'
require_relative '../../sales_taxes_app/receipt_renderer'

module SalesTaxesApp
  describe ReceiptRenderer do
    describe :render_receipt do

      context 'no csv file' do
        it 'builds the csv representation of the receipt' do
          receipt = 'Just a receipt'

          expect(ReceiptRenderer).to receive(:render_receipt_to_string).with receipt

          ReceiptRenderer.render_receipt receipt
        end

        it 'outputs the rendered receipt to the standard output' do
          rendered = 'Jsut a astring'
          allow(ReceiptRenderer).to receive(:render_receipt_to_string).and_return rendered

          expect(ReceiptRenderer).to receive(:puts).with rendered

          ReceiptRenderer.render_receipt 'A receipt object'
        end

        it 'raises an exception when the rendering process fails' do
          allow(ReceiptRenderer).to receive(:render_receipt_to_string).and_raise 'Something went wrong'
          expect{ReceiptRenderer.render_receipt ''}.to raise_error
        end
      end

      context 'with csv file' do

        let(:output_file_path) { 'Just a file path' }

        before :each do
          allow(ReceiptRenderer).to receive :write_summary_into_file
        end

        it 'builds the csv representation of the receipt' do
          receipt = 'Just a receipt'

          expect(ReceiptRenderer).to receive(:render_receipt_to_string).with receipt

          ReceiptRenderer.render_receipt receipt, output_file_path
        end

        it 'outputs the rendered receipt to the given file' do
          rendered = 'Jsut a astring'
          allow(ReceiptRenderer).to receive(:render_receipt_to_string).and_return rendered

          expect(ReceiptRenderer).to receive(:write_summary_into_file).with rendered, output_file_path

          ReceiptRenderer.render_receipt 'A receipt object', output_file_path
        end

        it 'raises an exception when the rendering process fails' do
          allow(ReceiptRenderer).to receive(:render_receipt_to_string).and_raise 'Something went wrong'
          expect{ReceiptRenderer.render_receipt '', output_file_path}.to raise_error
        end
      end
    end

    describe :render_receipt_to_string do

      let(:item) { double Models::ReceiptItem, quantity: 2, product: 'NaMe', price: 1.0, taxes_amount: 1.0 }
      let(:items) { [item] }
      let(:receipt) { double Models::Receipt, items: items, total_price: 123.99, taxes_amount: 543.56 }

      before :each do
        allow(TaxesCalculator).to receive(:find_tax_percentage).and_return 0
        allow(receipt).to receive :taxes_amount=
      end

      subject { ReceiptRenderer.send :render_receipt_to_string, receipt }

      it 'renders a line with the info in the item' do
        text_line = [item.quantity, item.product, '%.2f' % (item.price + item.taxes_amount)].join ', '
        expect(subject).to include text_line
      end

      it 'renders a line with the info for each item in the receipt' do
        item2 = double Models::ReceiptItem, quantity: 2.22, product: 'NaMe2', price: 2.2, taxes_amount: 1.3
        items << item2
        text_line1 = [item.quantity, item.product, '%.2f' % (item.price + item.taxes_amount)].join ', '
        text_line2 = [item2.quantity, item2.product, '%.2f' % (item2.price + item2.taxes_amount)].join ', '

        expect(subject).to include [text_line1, text_line2].join("\n")
      end

      it 'renders the tax and price total at the end of the listing' do
        summary_text = "Sales Taxes: #{receipt.taxes_amount}\nTotal: #{receipt.total_price}"
        expect(subject).to include summary_text
      end

      it 'only renders the tax and price total when no items' do
        items.clear
        summary_text = "Sales Taxes: #{receipt.taxes_amount}\nTotal: #{receipt.total_price}"
        expect(subject).to eql summary_text
      end
    end

    describe :write_summary_into_file do

      let(:summary) { 'The report' }
      let(:output_file_path) { 'Just a path' }
      let(:file) { double(File).as_null_object }

      before :each do
        allow(File).to receive(:new).and_return file
      end

      subject { ReceiptRenderer.send :write_summary_into_file, summary, output_file_path }

      it 'creates a new file with the given path' do
        expect(File).to receive(:new).with output_file_path, 'w'
        subject
      end

      it 'writes the summary in the created file' do
        expect(file).to receive(:write).with summary
        subject
      end

      it 'closes the created file' do
        expect(file).to receive :close
        subject
      end

      it 'raises an exception when error while writing the file' do
        allow(file).to receive(:write).and_raise 'Write exception'
        expect{ subject }.to raise_error
      end

      it 'closes the file when error while writing the file' do
        allow(file).to receive(:write).and_raise 'Write exception'
        expect(file).to receive :close
        subject rescue nil
      end
    end
  end
end
