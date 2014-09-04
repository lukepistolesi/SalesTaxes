module SalesTaxesApp
  class ReceiptRenderer
    def self.render_receipt(receipt, output_file_path=nil)
      summary = self.render_receipt_to_string receipt
      if output_file_path.nil?
        puts summary
      else
        self.write_summary_into_file summary, output_file_path
      end
    end

    private

    def self.render_receipt_to_string(receipt)
      buffer = receipt.items.inject(StringIO.new) do |buffer, item|
        full_price_text = '%.2f' % (item.price + item.taxes_amount)
        buffer << [item.quantity, item.product, full_price_text].join(', ')
        buffer << "\n"
      end
      buffer << "Sales Taxes: #{'%.2f' % receipt.taxes_amount}\nTotal: #{'%.2f' % receipt.total_price}"
      buffer.string
    end

    def self.write_summary_into_file(summary, file_path)
      file = File.new file_path, 'w'
      begin
        file.write summary
      ensure
        file.close
      end
    end
  end
end
