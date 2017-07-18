module Label
  STANDARD_LABEL = "http://www.xbrl.org/2003/role/label"
  VERBOSE_LABEL  = "http://www.xbrl.org/2003/role/verboseLabel"

  def get_label(locator, preferred_label, english_flag=false)
    label_files = english_flag ? CoolXBRL::EDINET.label_en : CoolXBRL::EDINET.label
    role = preferred_label || STANDARD_LABEL

    if /http\:\/\// =~ locator
      name, doc = label_files[:edinet]
      href = "../#{File.basename(locator)}"
    else
      name, doc = label_files[:presenter]
      href = locator
    end

    locator_label = doc.at_xpath("//link:loc[@xlink:href='#{href}']/@xlink:label").to_s
    doc.xpath("//link:labelArc[@xlink:from='#{locator_label}']/@xlink:to").each do |to|
      label = doc.at_xpath("//link:label[@xlink:label='#{to.to_s}' and @xlink:role='#{role}']/text()").to_s
      break label unless label.empty?
    end
  end
end