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
        #Dir.chdir(dir)
        #doc = File.open(Dir.glob("XBRL/PublicDoc/**/*.xbrl").first) {|file| Nokogiri::XML file }
        #read doc
        get_taxonomy dir
        return xsd, presentation, label, label_en, xbrl
        #Presentation.parse dir

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