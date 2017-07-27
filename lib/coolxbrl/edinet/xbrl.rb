require "coolxbrl/edinet/xbrl/data_set"
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
          doc.xpath("//#{name.gsub(/(?<=jppfs\_.{3}|jp.{3}\d{6}\-.{3}\_[EG]\d{5}\-\d{3})_/, ":")}").each_with_object(DataSet.new) do |data, stack|
            context_ref = data.at_xpath("@contextRef").to_s
            stack << Data.new(data.at_xpath("text()").to_s,
                              context_ref,#data.at_xpath("@contextRef").to_s,
                              data.at_xpath("@unitRef").to_s,
                              data.at_xpath("@decimals").to_s) unless stack.has_context_ref?(context_ref)
          end
        end

        def create_period(contextRef)
          doc = CoolXBRL::EDINET.xbrl
          doc.xpath("//xbrli:context[@id='#{contextRef}']/xbrli:period/*/text()").map do |text|
            text.to_s.gsub(/\-/, "/")
          end.to_a.join("-")
        end
      end
    end
  end
end