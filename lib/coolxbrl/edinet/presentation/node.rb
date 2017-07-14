module CoolXBRL
  module EDINET
    class Presentation
      class Node
        @@nodes = []
        #@@child_nodes = []

        attr_accessor :name, :children, :order

        def initialize(parent_name: nil, child_name: nil, order: nil)
          if parent = Node.exist?(parent_name)
            parent.children << create_children(child_name, order)

            #@@child_nodes << parent.children.last
          else
            @name = parent_name
            @children = child_name ? [create_children(child_name, order)] : []

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
        def create_children(child_name, order)
          child = Node.exist?(child_name) || Node.new(parent_name: child_name)
          child.order = order
          child
        end
      end
    end
  end
end