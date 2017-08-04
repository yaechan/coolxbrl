module CoolXBRL
  module EDINET
    class Presentation
      class Node
        @@nodes = NodeSet.new
        #@@child_nodes = []

        attr_accessor :name, :locator, :children, :order, :preferred_label, :label, :data

        def initialize(parent: nil, child: nil, order: nil, preferred_label: "", axis: [])
          preferred_label = preferred_label.empty? ? nil : preferred_label

          if parent_node = Node.exist?(parent[:name])
            parent_node.children << create_children(child, order, preferred_label, axis)

            #@@child_nodes << parent.children.last
          else
            @name     = parent[:name]
            @locator  = parent[:locator]
            @children = child ? NodeSet[create_children(child, order, preferred_label, axis)] : NodeSet.new

            @@nodes << self
            #@@child_nodes << @children.first if child_name
          end
        end

        def data?
          !self.data.nil? && !self.data.empty?
        end

        def children?
          !self.children.empty?
        end

        def children_with_index(index)
          self.children.sort_by{|child| child.order.to_i }
                       .map{|child| [child, index] }
        end

        def to_csv(indent_flag=true, header_flag=true)
          nodes = [[self, -1]]
          header = []
          CSV.generate do |csv|
            until nodes.empty?
              node, index = nodes.shift
              indent = "  " * ((indent_flag && index >= 0) ? index : 0)

              if node.data?
                node.data.to_hash.each do |context_ref, context_data|
                  label_data = [indent + node.label, context_data[:label].join("|")]
                  csv << context_data[:data].inject(label_data) do |stack, period_data|
                    value = period_data[:value]
                    header << period_data[:period] unless header.length == 4
                    stack.push(value.empty? ? "-" : value)
                  end
                end
              else
                if /(?<=\_)[^\_]+(Heading|Table|Axis|Member)$/ =~ node.name
                  match = $&
                  case match
                  when /Heading/
                    header[0] = node.label
                  when /Axis/
                    current_axis = match
                  when /Member/
                    header[1] = node.label if current_axis == "ConsolidatedOrNonConsolidatedAxis"
                  end

                  csv << [indent + node.label] if header_flag && $& != "Heading"
                else
                  csv << [indent + node.label]
                end
              end

              nodes.unshift(*node.children_with_index(index + 1)) if node.children?
            end
          end.gsub(/^#{header[0]}$/).with_index(1) {|row, index| index == (header_flag ? 2 : 1) ? header.join(",") : row }
          #end.insert(0, header.join(",") + "\n")
        end

        class << self
          def nodes
            @@nodes
          end

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
        def create_children(child, order, preferred_label, axis)
          child_node = Node.exist?(child[:name]) || Node.new(parent: child)
          child_node.label ||= CoolXBRL::EDINET::Label.get_label(child[:locator], preferred_label)
          child_node.data ||= CoolXBRL::EDINET::XBRL.get_data(child[:name], preferred_label, axis)
          child_node.order = order
          child_node.preferred_label = preferred_label unless preferred_label.nil?
          child_node
        end
      end
    end
  end
end