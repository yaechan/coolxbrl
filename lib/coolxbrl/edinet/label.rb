require "pathname"

module Label
  def get_label(locator, english_flag=false)
    label_files = english_flag ? CoolXBRL::EDINET.label_en : CoolXBRL::EDINET.label
    label_files.each do |name, doc|
      if /http\:\/\/disclosure\.edinet\-fsa\.go\.jp\/taxonomy\/jppfs\// =~ name
        puts locator
        puts name
        puts Pathname(locator).relative_path_from(Pathname(name)).to_s
        puts File.join(name, doc.xpath("//link:loc[1]/@xlink:href").to_s)
      else
      end
    end
  end
end