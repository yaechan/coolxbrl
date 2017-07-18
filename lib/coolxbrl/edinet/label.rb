module Label
  STANDARD_LABEL = "http://www.xbrl.org/2003/role/label"
  VERBOSE_LABEL  = "http://www.xbrl.org/2003/role/verboseLabel"

  def get_label(locator, preferred_label, english_flag=false)
    label_files = english_flag ? CoolXBRL::EDINET.label_en : CoolXBRL::EDINET.label
    if /http\:\/\// =~ locator
      name, doc = label_files[:edinet]
      locator_label = doc.xpath("//link:loc[contains(./@xlink:href, '#{File.basename(locator)}')]/@xlink:label").to_s
        role = preferred_label || STANDARD_LABEL
        puts locator_label
        puts locator
        puts role
      doc.xpath("//link:labelArc[@xlink:from='#{locator_label}']/@xlink:to").each do |to|
        puts doc.xpath("//link:label[@xlink:label='#{to.to_s}' and @xlink:role='#{role}']/text()")
      end
        puts "-"*30
    else
      name, doc = label_files[:presenter]
    end
  end
end