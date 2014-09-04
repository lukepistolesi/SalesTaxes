module SalesTaxesApp::Models
  class ReceiptItem
    def initialize(quantity, product_name, price)
      @quantity = quantity
      @product = product_name
      @price = price
      @taxes_amount = 0.0
    end

    def quantity; @quantity end

    def product; @product end

    def price; @price end

    def taxes_amount; @taxes_amount end

    def taxes_amount=(amount); @taxes_amount = amount end
  end
end
