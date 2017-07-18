module Label
  def get_label(locator, english_flag=false)
    label_files = english_flag ? CoolXBRL::EDINET.label_en : CoolXBRL::EDINET.label
    label_files.each do |name, doc|
      puts name
    end
  end
end