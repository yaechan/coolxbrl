module CoolXBRL
  module EDINET
    class Presentation
      class Node
        @@nodes = []
        #@@child_nodes = []

        attr_accessor :name, :locator, :children, :order, :preferred_label

        def initialize(parent: nil, child: nil, order: nil, preferred_label: "")
          puts parent
          if parent = Node.exist?(parent[:name])
            parent.children << create_children(child, order, preferred_label)

            #@@child_nodes << parent.children.last
          else
            @name     = parent[:name]
            @locator  = parent[:locator]
            @children = child ? [create_children(child, order, preferred_label)] : []

            @@nodes << self
            #@@child_nodes << @children.first if child_name
          end
        end

        class << self
          def nodes
            @@nodes
          end

          #TODO order属性が必ず入るなら（order=1）、orderの有無でtop_nodeの判断をしてもいいかも。
          def top_node
            #@@nodes - @@child_nodes
            @@nodes.find {|node| !node.instance_variable_defined?(:@order)}
          end

          def exist?(parent_name)
            @@nodes.find {|node| node.name == parent_name }
          end

          def clear_class_variables
            @@nodes = []
            #@@child_nodes = []
          end
        end

        private
        def create_children(child, order, preferred_label)
          child = Node.exist?(child[:name]) || Node.new(parent: child)
          child.order = order
          child.preferred_label = preferred_label unless preferred_label.empty?
          child
        end
      end
    end
  end
end