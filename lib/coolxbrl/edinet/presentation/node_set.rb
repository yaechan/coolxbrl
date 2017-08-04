module CoolXBRL
  module EDINET
    class Presentation
      class NodeSet < Array
        include Set

        def to_csv(indent_flag=true, header_flag=false)
          self.map {|node| node.to_csv(indent_flag, header_flag) }
        end
      end
    end
  end
end