require_relative '../../spec_helper'
require_relative '../../../sales_taxes_app/models/receipt'

module SalesTaxesApp::Models
  describe Receipt do

    describe :initialize do
      it 'sets an empty items collection' do
        receipt = Receipt.new
        expect(receipt.instance_variable_get :@items).to be_empty
      end

      it 'sets the items collection to the given one' do
        collection = []
        receipt = Receipt.new collection
        expect(receipt.instance_variable_get :@items).to eql collection
      end

      it 'sets the taxes amount to zero' do
        receipt = Receipt.new
        expect(receipt.instance_variable_get :@taxes_amount).to eql 0.0
      end

      it 'sets the total price to zero' do
        receipt = Receipt.new
        expect(receipt.instance_variable_get :@total_price).to eql 0.0
      end
    end

    describe :items do
      it 'returns the collection in the instance' do
        collection = []
        receipt = Receipt.new collection
        expect(receipt.items).to eql collection
      end
    end

    describe :items= do
      it 'sets the collection in the instance' do
        collection = []
        receipt = Receipt.new
        receipt.items = collection
        expect(receipt.items).to eql collection
      end
    end

    describe :taxes_amount do
      it 'returns the amount in the instance' do
        amount = 123.34
        receipt = Receipt.new
        receipt.instance_variable_set :@taxes_amount, amount
        expect(receipt.taxes_amount).to eql amount
      end
    end

    describe :taxes_amount= do
      it 'sets the amount in the instance' do
        amount = 123.56
        receipt = Receipt.new
        receipt.taxes_amount = amount
        expect(receipt.taxes_amount).to eql amount
      end
    end

    describe :total_price do
      it 'returns the total price in the instance' do
        total_price = 123.34
        receipt = Receipt.new
        receipt.instance_variable_set :@total_price, total_price
        expect(receipt.total_price).to eql total_price
      end
    end

    describe :total_price= do
      it 'sets the total price in the instance' do
        total_price = 123.56
        receipt = Receipt.new
        receipt.total_price = total_price
        expect(receipt.total_price).to eql total_price
      end
    end
  end
end