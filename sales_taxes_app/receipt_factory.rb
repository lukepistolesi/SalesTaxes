require 'csv'

module SalesTaxesApp
  class ReceiptFactory
    def self.from_csv(file_path)
      receipt = Models::Receipt.new
      items = []
      CSV.foreach(file_path, headers: true, header_converters: lambda {|f| f.strip}) do |row|
        items << Models::ReceiptItem.new(row['Quantity'].strip, row['Product'].strip, row['Price'].strip.to_f)
      end
      receipt.items = items || []
      receipt
    end
  end
end