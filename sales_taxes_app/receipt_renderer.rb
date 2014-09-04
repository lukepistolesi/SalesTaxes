module SalesTaxesApp
  class ReceiptRenderer
    def self.render_receipt(receipt)
      puts self.render_receipt_to_string receipt
    end

    private

    def self.render_receipt_to_string(receipt)
      buffer = receipt.items.inject(StringIO.new) do |buffer, item|
        buffer << [item.quantity, item.product, item.price].join(', ')
        buffer << "\n"
      end
      buffer << "Sales Taxes: #{receipt.taxes_amount}\nTotal: #{receipt.total_price}"
      buffer.string
    end
  end
end
