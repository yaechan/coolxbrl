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
          hash = {}
          tables.each do |table|
            Node.clear_class_variables
            #table.xpath("link:presentationArc[contains(./@xlink:from, 'Heading')]").each do |heading|
            table.xpath("link:presentationArc").each do |arc|
              parent_name = arc.at_xpath("@xlink:from").to_s
              child_name  = arc.at_xpath("@xlink:to").to_s
              puts parent_name
              Node.new(parent:          { name: parent_name, locator: table.xpath("link:loc[@xlink:label='#{parent_name}']/@xlink:href").to_s },
                       child:           { name: child_name, locator: table.xpath("link:loc[@xlink:label='#{child_name}']/@xlink:href").to_s },
                       order:           arc.at_xpath("@order").to_s,
                       preferred_label: arc.at_xpath("@preferredLabel").to_s)
            end
            #table.xpath("//link:loc/@xlink:href") do |location_href|
            #  nodes[:name] = location_href
            #  if table.at_xpath("//")
            #end

            hash[table.xpath("@xlink:role").to_s] = Node.top_node
          end
          hash
        end
      end
    end
  end
end