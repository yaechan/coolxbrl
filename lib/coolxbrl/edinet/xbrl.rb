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
          doc.xpath("//#{name.gsub(/(?<=jppfs\_.{3})_/, ":")}").inject([]) do |stack, data|
            stack << Data.new(data.at_xpath("text()").to_s,
                              data.at_xpath("@contextRef").to_s,
                              data.at_xpath("@unitRef").to_s,
                              data.at_xpath("@decimals").to_s)
          end
        end

        def create_period(contextRef)
          doc = CoolXBRL::EDINET.xbrl
          puts doc.xpath("//xbrli:context[@id='#{contextRef}']/xbrli:period/*/text()").methods
          puts doc.xpath("//xbrli:context[@id='#{contextRef}']/xbrli:period/*/text()").to_a
          puts doc.xpath("//xbrli:context[@id='#{contextRef}']/xbrli:period/*/text()").class
          exit 0
        end
      end
    end
  end
end