module SalesTaxesApp
  module Models

    class Receipt

      def initialize(collection=[])
        @items = collection
        @taxes_amount = 0.0
        @total_price = 0.0
      end

      def items; @items end

      def items=(items_collection)
        @items = items_collection
      end

      def taxes_amount; @taxes_amount end

      def taxes_amount=(taxes_amount)
        @taxes_amount = taxes_amount
      end

      def total_price; @total_price end

      def total_price=(total_price)
        @total_price = total_price
      end
    end

  end
end
