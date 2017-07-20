module CoolXBRL
  module EDINET
    class XBRL
      class Data
        attr_accessor :value, :contextRef, :unitRef, :decimals

        def initialize(value, contextRef, unitRef, decimals)
          @value      = value
          @contextRef = contextRef
          @unitRef    = unitRef
          @decimals   = decimals
        end
      end
    end
  end
end