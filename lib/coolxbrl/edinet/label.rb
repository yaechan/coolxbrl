module Label
  def get_label(locator, english_flag=false)
    label_files = english_flag ? CoolXBRL::EDINET.label_en : CoolXBRL::EDINET.label
    /http\:\/\// =~ locator
  end
end