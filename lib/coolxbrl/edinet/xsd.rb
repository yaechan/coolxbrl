require "open-uri"

module XSD
  attr_accessor :xsd, :presentation, :label, :xbrl

  def get_taxonomy(dir, language)
    @language_pattern = set_language_pattern(language)
    get_presenters_files(dir)
    get_edinet_files(@xsd)
  end

  def set_language_pattern(language)
    case language
    when :ja
      "_lab.xml"
    when :en
      "_lab-en"
    else
      raise "LanguageError"
    end
  end

  def get_presenters_files(dir)
    @xsd          = get_presenters_file(dir, ".xsd")
    @presentation = get_presenters_file(dir, "_pre.xml")
    @xbrl         = get_presenters_file(dir, ".xbrl")
    @label = get_presenters_file(dir, @language_pattern, true)
  end

  def get_presenters_file(dir, pattern, hash_flag=false)
    Dir.chdir(dir)
    files = Dir.glob("XBRL/PublicDoc/**/*#{pattern}")
    if hash_flag
      result = {}
      files.each do |file_name|
        #result[File.join(dir, file_name)] = File.open(file_name) {|file| Nokogiri::XML file }
        result[:presenter] = [File.join(dir, file_name), File.open(file_name) {|file| Nokogiri::XML file }]
      end
    else
      result = File.open(files.first) {|file| Nokogiri::XML file }
    end

    return result
  end

  def get_edinet_files(xsd)
    @label[:edinet] = get_edinet_file(xsd, @language_pattern)
  end

  def get_edinet_file(xsd, pattern)
    xsd.xpath("//link:linkbaseRef[contains(./@xlink:href, '#{pattern}')]/@xlink:href").each do |href|
      href = href.to_s
      if /^http\:\/\/disclosure\.edinet\-fsa\.go\.jp\/taxonomy\/jppfs\// =~ href
        return href, open(href) {|file| Nokogiri::XML file }
      end
    end
  end
end