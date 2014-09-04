require_relative '../spec_helper'
require_relative '../../sales_taxes_app/taxes_calculator'

module SalesTaxesApp

  describe TaxesCalculator do

    describe :compute_taxes! do

      let(:exemptions) { Set.new }
      let(:item) { double(Models::ReceiptItem, price: 1.0, taxes_amount: 2.0).as_null_object }
      let(:items) { [item] }
      let(:receipt) { double Models::Receipt, items: items }

      before :each do
        allow(TaxesCalculator).to receive(:gst_exempted_keywords).and_return exemptions
        allow(TaxesCalculator).to receive(:find_tax_percentage).and_return 0
        allow(receipt).to receive :taxes_amount=
      end

      subject { TaxesCalculator.compute_taxes! receipt }

      it 'retrieves the exemptions' do
        expect(TaxesCalculator).to receive(:gst_exempted_keywords).and_return Set.new
        subject
      end

      it 'computes the tax percentage for a receipt item' do
        expect(TaxesCalculator).to receive(:find_tax_percentage).with(item, exemptions).and_return 0

        subject
      end

      it 'assign the rounded computed tax value to the item' do
        price, percentage = [ 100.0, 3.0 ]
        expected_tax_amount = price.to_f * (1.0 - 100.0/(100.0 + percentage))
        expected_tax_amount = (expected_tax_amount * 20).round / 20.0

        allow(TaxesCalculator).to receive(:find_tax_percentage).and_return percentage
        allow(item).to receive(:price).and_return price
        expect(item).to receive(:taxes_amount=).with expected_tax_amount

        subject
      end

      it 'assigns zero tax amount to the item when no taxes for it' do
        expect(item).to receive(:taxes_amount=).with 0.0

        subject
      end

      it 'assigns the rounded tax total to the receipt' do
        second_item = double(Models::ReceiptItem, price: 1.0, taxes_amount: 12).as_null_object
        items << second_item
        first_taxes_amount = 11.32
        allow(item).to receive(:taxes_amount).and_return first_taxes_amount
        expected_total_tax_amount = first_taxes_amount + second_item.taxes_amount
        expected_total_tax_amount = (expected_total_tax_amount * 20).round / 20.0

        expect(receipt).to receive(:taxes_amount=).with expected_total_tax_amount

        subject
      end

      it 'assigns zero tax total when no items' do
        items.clear
        expect(receipt).to receive(:taxes_amount=).with 0.0

        subject
      end

      it 'assigns zero tax total when no taxes for the only item' do
        allow(item).to receive(:taxes_amount).and_return 0.0
        expect(receipt).to receive(:taxes_amount=).with 0.0

        subject
      end
    end


    describe :find_tax_percentage do

      let(:product_name_words) { ['first', 'second'] }
      let(:item) { double Models::ReceiptItem, product: product_name_words.join(' ') }
      let(:gst_exempted_keywords) { Set.new }

      subject { TaxesCalculator.find_tax_percentage item, gst_exempted_keywords }

      context 'GST exempted product' do

        [:food, :books, :medical].each do |category|

          it 'returns zero percentage when the product is part of the category' do
            gst_exempted_keywords << 'banana'
            product_name_words.replace ['banana', 'split']

            expect(subject).to eql 0.0
          end

          it 'returns zero percentage when the product name has uppercase letters' do
            gst_exempted_keywords << 'banana'
            product_name_words.replace ['Banana', 'Split']

            expect(subject).to eql 0.0
          end

          it 'returns GST percentage when the product name is not in the category' do
            gst_exempted_keywords << 'banana'
            product_name_words.replace ['TV', 'Led']

            expect(subject).to eql 10.0
          end

          it 'returns GST percentage when there are no food listed' do
            product_name_words.replace ['Banana', 'sweet']

            expect(subject).to eql 10.0
          end
        end
      end
    end

    describe :gst_exempted_keywords do

      let(:settings) { {keywords: { food: '', books: '', medical: '' }} }
      let(:mock_config) { double Configuration, settings: settings }

      before :each do
        allow(Configuration).to receive(:instance).and_return mock_config
      end

      subject { TaxesCalculator.gst_exempted_keywords }

      it 'fetches the configuration settings' do
        expect(mock_config).to receive :settings
        subject
      end

      it 'returns the union of all the gst exempted keywords' do
        food = settings[:keywords][:food] = 'One Food'
        books = settings[:keywords][:books] = 'pride and prejudice'
        medical = settings[:keywords][:medical] = 'Aspirin'

        expect(subject).to eql Set.new([food, books, medical])
      end

      it 'returns the union of all the stripped gst exempted keywords' do
        food = settings[:keywords][:food] = 'One, Food'
        books = settings[:keywords][:books] = 'pride , prejudice'
        medical = settings[:keywords][:medical] = 'Aspirin'

        expected_keywords = food.split(',') + books.split(',') + medical.split(',')
        expect(subject).to eql Set.new(expected_keywords.map &:strip)
      end
    end

  end

  describe :compute_total_price! do

    let(:item) { double Models::ReceiptItem, price: 1.0, taxes_amount: 2.0 }
    let(:items) { [item] }
    let(:receipt) { double Models::Receipt, items: items }

    before :each do
      allow(receipt).to receive :total_price=
    end

    subject { TaxesCalculator.compute_total_price! receipt }

    it 'gets the price for each item' do
      expect(item).to receive(:price).and_return 1.0
      subject
    end

    it 'sets the sum of the item prices in the receipt object' do
      second_item = double Models::ReceiptItem, price: 2.0
      items << second_item
      allow(item).to receive(:price).and_return 1.0
      expect(receipt).to receive(:total_price=).with item.price + second_item.price

      subject
    end
  end
end
