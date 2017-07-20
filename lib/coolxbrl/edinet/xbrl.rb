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
          doc.xpath("//#{name.gsub(/(?<=jppsf\_.{3})_/, ":")}").each do |data|
            puts data.at_xpath("text()").to_s
            puts data.at_xpath("@contextRef").to_s
          end
          #Data.new(value, contextRef, unitRef, decimals)
        end
      end
    end
  end
end