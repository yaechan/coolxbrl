module CoolXBRL
  module EDINET
    class Presentation
      class NodeSet < Array
        include Set

        def to_csv(indent_flag=true)
          self.map {|node| node.to_csv(indent_flag) }
        end
      end
    end
  end
end