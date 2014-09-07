require 'optparse'
Dir['./sales_taxes_app/**/*.rb'].each { |f| require f }

module SalesTaxesApp
  class Application
    def self.run(args)
      options = parse_command_line_opts args
      receipt = ReceiptFactory.from_csv options[:input_file]
      TaxesCalculator.compute_taxes! receipt
      TaxesCalculator.compute_total_price! receipt
      ReceiptRenderer.render_receipt receipt, options[:output_file]
    end

    def self.parse_command_line_opts(args)
      raise 'Wrong number of arguments' if args.size == 0

      opts = {}

      op = OptionParser.new do |opt|
          opt.banner = 'extract_taxes [options] <file>'
          opt.separator ''

          opt.on('-o', '--output [FILE_NAME]', 'CSV output file') { |fn| opts[:output_file] = fn }
      end

      params = op.parse!(args)
      raise 'Wrong number of arguments' if params.size != 1

      { input_file: params.first, output_file: opts[:output_file] }
    end
  end
end
