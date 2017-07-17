require "coolxbrl/edinet/balance_sheet"
require "coolxbrl/edinet/profit_and_loss_statement"
require "coolxbrl/edinet/statement_of_cash_flow"
require "coolxbrl/edinet/statement_of_comprehensive_income"
require "coolxbrl/edinet/statement_of_shareholders_equity"
require "coolxbrl/edinet/document_information"
require "coolxbrl/edinet/presentation"
require "coolxbrl/edinet/xsd"

module CoolXBRL
  module EDINET
    extend XSD

    class << self
      def parse(dir)
        get_taxonomy dir
        Presentation.parse presentation

      end

#      def get_file(dir, pattern)
#        Dir.chdir(dir)
#        File.open(Dir.glob("XBRL/PublicDoc/**/#{pattern}").first) {|file| Nokogiri::XML file }
#      end

      private
      def read(doc)
      end

      def get_xbrl(path)
      end
    end
  end
end