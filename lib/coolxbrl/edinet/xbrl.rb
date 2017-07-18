require "coolxbrl/edinet/xbrl/data"

module CoolXBRL
  module EDINET
    class XBRL
      class << self
        def parse(xbrl_doc)
          get_data(xbrl_doc)
        end

        def get_data(xbrl_doc)
        end
      end
    end
  end
end