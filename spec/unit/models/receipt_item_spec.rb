require_relative '../../spec_helper'
require_relative '../../../sales_taxes_app/models/receipt_item'

module SalesTaxesApp::Models
  describe ReceiptItem do
    describe :initialize do
      it 'allocates an object with the given attributes' do
        qt = 2
        product_name = 'My name'
        price = 123.76
        item = ReceiptItem.new qt, product_name, price
        expect(item.instance_variable_get :@quantity).to eql qt
        expect(item.instance_variable_get :@product).to eql product_name
        expect(item.instance_variable_get :@price).to eql price
      end

      it 'sets the tax amount to zero' do
        item = ReceiptItem.new 1, '', 12
        expect(item.instance_variable_get :@taxes_amount).to eql 0.0
      end
    end

    describe 'accessors' do
      before :each do
        @item = ReceiptItem.new 12, 'name', 23
        @item.instance_variable_set :@taxes_amount, 111.2
      end

      [:quantity, :product, :price, :taxes_amount].each do |field|
        it "returns the vauel of the #{field} field" do
          expect(@item.send field).not_to be_nil
        end
      end

      describe :taxes_amount= do
        it 'sets the taxes amount in the instance' do
          new_item = ReceiptItem.new nil, nil, nil
          new_item.taxes_amount = 190
          expect(new_item.taxes_amount).to eql 190
        end
      end
    end

  end
end