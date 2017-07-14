require "coolxbrl/edinet/presentation/node"

module CoolXBRL
  module EDINET
    class Presentation
      class << self
        def parse(dir)
          presentation_doc = CoolXBRL::EDINET.get_file(dir, "*_pre.xml")
          get_financial_statements(presentation_doc)
        end

        def get_financial_statements(presentation_doc)
          tables = presentation_doc.xpath("//link:presentationLink[contains(./@xlink:role, 'http://disclosure.edinet-fsa.go.jp/role/jppfs/')]")

          to_hash tables
        end

        def to_hash(tables)
          array = {}
          tables.each do |table|
            Node.clear_class_variables
            #table.xpath("link:presentationArc[contains(./@xlink:from, 'Heading')]").each do |heading|
            table.xpath("link:presentationArc").each do |arc|
              Node.new(parent_name: arc.xpath("@xlink:from").to_s,
                       child_name:  arc.xpath("@xlink:to").to_s,
                       order:       arc.xpath("@order").to_s)
            end
            #table.xpath("//link:loc/@xlink:href") do |location_href|
            #  nodes[:name] = location_href
            #  if table.at_xpath("//")
            #end

            array[table.xpath("@xlink:role").to_s] = Node.top_node
          end
          array
        end
      end
    end
  end
end