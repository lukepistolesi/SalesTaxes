module SalesTaxesApp
  class TaxesCalculator

    @@gst_exempted_keywords = nil

    def self.compute_taxes!(receipt)
      exemptions = self.gst_exempted_keywords
      imports = self.import_taxation_keywords
      full_taxes_amount =
        receipt.items.inject(0.0) do |sum, item|
          percentage = self.find_tax_percentage item, exemptions, imports
          item.taxes_amount = compute_tax_amount item.price, percentage
          sum += item.taxes_amount
        end
      receipt.taxes_amount = (full_taxes_amount * 20).round / 20.0
    end

    def self.compute_total_price!(receipt)
      receipt.total_price =
        receipt.items.inject(0.0) do |sum, item|
          sum += item.price + item.taxes_amount
        end.round 2
    end

    private

    def self.compute_tax_amount(cost, percentage)
      full_taxes = cost * percentage
      mod = full_taxes % 5
      full_taxes += (5 - mod) if mod != 0
      (full_taxes/100.0).round 2
    end

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
