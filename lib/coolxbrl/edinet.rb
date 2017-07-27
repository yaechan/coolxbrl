require "coolxbrl/edinet/document_information"
require "coolxbrl/edinet/presentation"
require "coolxbrl/edinet/xbrl"
require "coolxbrl/edinet/xsd"
require "coolxbrl/edinet/label"

module CoolXBRL
  module EDINET
    extend XSD
    #extend Label

    class << self
      def parse(dir, language=Label::DEFAULT_LANGUAGE)
        get_taxonomy dir, language
        Presentation.parse presentation
      end

      def parse_table(dir, consolidated, table, language=Label::DEFAULT_LANGUAGE)
        get_taxonomy dir, language
        Presentation.parse_table(presentation, consolidated, table)
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