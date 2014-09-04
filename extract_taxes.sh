#!/usr/bin/env ruby
require './sales_taxes_app/application.rb'

#SalesTaxesApp::Application.run ARGV
SalesTaxesApp::Application.parse_command_line_opts ARGV
