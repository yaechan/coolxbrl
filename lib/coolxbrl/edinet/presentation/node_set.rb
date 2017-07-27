module CoolXBRL
  module EDINET
    class Presentation
      class NodeSet < Array
        include Set

        def odd
          select {|f| f.class == "Node" }
        end
      end
    end
  end
end