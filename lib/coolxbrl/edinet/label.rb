module CoolXBRL
  module EDINET
    class Label
      DEFAULT_LANGUAGE = :ja
      STANDARD_LABEL   = "http://www.xbrl.org/2003/role/label"
      VERBOSE_LABEL    = "http://www.xbrl.org/2003/role/verboseLabel"

      class << self
        def get_label(locator, preferred_label=nil)
          #name, doc, href, role = create_params(locator, preferred_label, english_flag)
          search_label(*create_params(locator, preferred_label))
        end

        def get_context_label(context)
          search_context_label(*create_context_params(context))
        end

        def create_params(locator, preferred_label)
          label_files = CoolXBRL::EDINET.label
          role        = preferred_label || STANDARD_LABEL

          if /http\:\/\// =~ locator
            return *label_files[:edinet], "../#{File.basename(locator)}", role
          else
            return *label_files[:presenter], locator, role
          end
        end

        def create_context_params(context)
          label_files = CoolXBRL::EDINET.label
          role        = STANDARD_LABEL

          if /jp(crp|pfs)\d{6}\-(asr|ssr|q[1-5]r)\_[EG]\d{5}\-\d{3}/ =~ context
            return *label_files[:presenter], context.gsub(/(?<=#{$&})/, "_"), role
          else
            return *label_files[:edinet], context, role
          end
        end

        def search_context_label(name, doc, context, role)
          #確実な検索。時間が掛かる
          doc.xpath("//link:labelArc[@xlink:from='#{context}']/@xlink:to").each do |to|
            label = doc.at_xpath("//link:label[@xlink:label='#{to.to_s}' and @xlink:role='#{role}']/text()").to_s
            break label unless label.empty?
          end
          #不確実かもしれない検索。多少時間が速くなる
          #doc.xpath("//link:label[contains(./@xlink:label, '#{context}') and @xlink:role='#{role}']/text()").to_s
        end

        def search_label(name, doc, href, role)
          locator_label = doc.at_xpath("//link:loc[@xlink:href='#{href}']/@xlink:label").to_s
          #確実な検索。時間が掛かる
          doc.xpath("//link:labelArc[@xlink:from='#{locator_label}']/@xlink:to").each do |to|
            label = doc.at_xpath("//link:label[@xlink:label='#{to.to_s}' and @xlink:role='#{role}']/text()").to_s
            break label unless label.empty?
          end
          #不確実かもしれない検索。多少時間が速くなる
          #doc.xpath("//link:label[contains(./@xlink:label, '#{locator_label}') and @xlink:role='#{role}']/text()").to_s
        end
      end
    end
  end
end