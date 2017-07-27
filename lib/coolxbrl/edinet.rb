require "coolxbrl/edinet/document_information"
require "coolxbrl/edinet/xbrl"
require "coolxbrl/edinet/presentation"
require "coolxbrl/edinet/xsd"
require "coolxbrl/edinet/label"

module CoolXBRL
  module EDINET
    extend XSD

    class << self
      def parse(dir, language=Label::DEFAULT_LANGUAGE)
        get_taxonomy dir, language
        Presentation.parse presentation
      end

      def parse_table(dir, consolidated, table, language=Label::DEFAULT_LANGUAGE)
        get_taxonomy dir, language
        Presentation.parse_table(presentation, consolidated, table)
      end

      private
      def read(doc)
      end

      def get_xbrl(path)
      end
    end
  end
end