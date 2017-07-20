require "coolxbrl/edinet/xbrl/data"

module CoolXBRL
  module EDINET
    class XBRL
      class << self
        def parse(xbrl_doc)
          #get_data(xbrl_doc)
        end

        def get_data(name)
          doc = CoolXBRL::EDINET.xbrl
          puts name
          doc.xpath("//#{name.gsub(/(?<=jppfs\_.{3})_/, ":")}").each do |data|
            puts data.at_xpath("@contextRef").to_s
            puts data.at_xpath("text()").nil?
          end
          puts "-"*30
          #Data.new(value, contextRef, unitRef, decimals)
        end
      end
    end
  end
end