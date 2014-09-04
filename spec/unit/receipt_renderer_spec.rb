require_relative '../spec_helper'
require_relative '../../sales_taxes_app/receipt_renderer'

module SalesTaxesApp
  describe ReceiptRenderer do
    describe :render_receipt do
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

    describe :render_receipt_to_string do

      let(:item) { double Models::ReceiptItem, quantity: 2, product: 'NaMe', price: 1.0 }
      let(:items) { [item] }
      let(:receipt) { double Models::Receipt, items: items, total_price: 123.99, taxes_amount: 543.56 }

      before :each do
        allow(TaxesCalculator).to receive(:find_tax_percentage).and_return 0
        allow(receipt).to receive :taxes_amount=
      end

      subject { ReceiptRenderer.send :render_receipt_to_string, receipt }

      it 'renders a line with the info in the item' do
        text_line = [item.quantity, item.product, item.price].join ', '
        expect(subject).to include text_line
      end

      it 'renders a line with the info for each item in the receipt' do
        item2 = double Models::ReceiptItem, quantity: 2.22, product: 'NaMe2', price: 2.2
        items << item2
        text_line1 = [item.quantity, item.product, item.price].join ', '
        text_line2 = [item2.quantity, item2.product, item2.price].join ', '

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
  end
end
