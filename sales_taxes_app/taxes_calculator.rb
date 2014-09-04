module SalesTaxesApp
  class TaxesCalculator

    @@gst_exempted_keywords = nil

    def self.compute_taxes!(receipt)
      exemptions = self.gst_exempted_keywords
      imports = self.import_taxation_keywords
      full_taxes_amount =
        receipt.items.inject(0.0) do |sum, item|
          percentage = self.find_tax_percentage item, exemptions, imports
          full_taxes = item.price.to_f * (1.0 - 100.0/(100.0 + percentage))
          item.taxes_amount = (full_taxes * 20).round / 20.0
          sum += item.taxes_amount
        end
      receipt.taxes_amount = (full_taxes_amount * 20).round / 20.0
    end

    def self.compute_total_price!(receipt)
      receipt.total_price =
        receipt.items.inject(0.0) do |sum, item|
          sum += item.price.to_f
        end
    end

    private

    def self.find_tax_percentage(item, exemptions, imports)
      product_name_words = Set.new item.product.split(' ').map(&:downcase)
      percentage = 0.0
      percentage += 10.0 if (product_name_words & exemptions).empty?
      percentage += 5.0 unless (product_name_words & imports).empty?
      percentage
    end

    def self.gst_exempted_keywords
      keywords = Configuration.instance.settings[:keywords]
      Set.new(
        (keywords[:food].split(',') +
        keywords[:books].split(',') +
        keywords[:medical].split(',')).map(&:strip)
      )
    end

    def self.import_taxation_keywords
      Set.new Configuration.instance.settings[:keywords][:imported].split(',').map(&:strip)
    end
  end
end
