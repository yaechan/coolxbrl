module CoolXBRL
  module EDINET
    class Presentation
      class Node
        @@nodes = NodeSet.new
        #@@child_nodes = []

        attr_accessor :name, :locator, :children, :order, :preferred_label, :label, :data

        def initialize(parent: nil, child: nil, order: nil, preferred_label: "")
          preferred_label = preferred_label.empty? ? nil : preferred_label

          if parent_node = Node.exist?(parent[:name])
            parent_node.children << create_children(child, order, preferred_label)

            #@@child_nodes << parent.children.last
          else
            @name     = parent[:name]
            @locator  = parent[:locator]
            @children = child ? NodeSet[create_children(child, order, preferred_label)] : NodeSet.new

            @@nodes << self
            #@@child_nodes << @children.first if child_name
          end
        end

        def data?
          !self.data.empty?
        end

        def children?
          !self.children.empty?
        end

        def to_csv(indent_flag=true)
          CSV.generate do |csv|
            if self.data?
              self.data.to_csv do |data_row|
                csv << data_row.unshift(self.label)
              end
            else
              csv = [self.label, nil, nil]
            end

            self.children.to_csv(indent_flag) if self.children?
          end
        end

        class << self
          def nodes
            @@nodes
          end

          #TODO order属性が必ず入るなら（order=1）、orderの有無でtop_nodeの判断をしてもいいかも。
          def top_node
            #@@nodes - @@child_nodes
            node = @@nodes.find {|node| !node.instance_variable_defined?(:@order)}
            node.label ||= CoolXBRL::EDINET::Label.get_label(node.locator)
            node
          end

          def exist?(parent_name)
            @@nodes.find {|node| node.name == parent_name }
          end

          def clear_class_variables
            @@nodes = NodeSet.new
            #@@child_nodes = []
          end
        end

        private
        def create_children(child, order, preferred_label)
          child_node = Node.exist?(child[:name]) || Node.new(parent: child)
          child_node.label ||= CoolXBRL::EDINET::Label.get_label(child[:locator], preferred_label)
          child_node.data ||= CoolXBRL::EDINET::XBRL.get_data(child[:name])
          child_node.order = order
          child_node.preferred_label = preferred_label unless preferred_label.nil?
          child_node
        end
      end
    end
  end
end