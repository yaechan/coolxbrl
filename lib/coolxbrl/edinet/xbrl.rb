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
            #↓contextRefから～Memberを抜き出して配列にする正規表現
            #{contextRef}.scan(/(?<=\_).+?Member/)
            #{contextRef}.scan(/(?<=Instant\_|Duration\_|Member\_).+?Member/)
            stack << Data.new(data.at_xpath("text()").to_s,
                              data.at_xpath("@contextRef").to_s,
                              data.at_xpath("@unitRef").to_s,
                              data.at_xpath("@decimals").to_s)
          end
        end
      end
    end
  end
end