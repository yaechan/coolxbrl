require "open-uri"

module XSD
  attr_accessor :xsd, :presentation, :label, :label_en, :xbrl

  def get_taxonomy(dir)
    get_presenters_files(dir)
    get_edinet_files(@@xsd)
    puts @@xsd
  end

  def get_presenters_files(dir)
    @@xsd          = get_presenters_file(dir, "*.xsd")
    @@presentation = get_presenters_file(dir, "*_pre.xml")
    @@label        = get_presenters_file(dir, "*_lab.xml", true)
    @@label_en     = get_presenters_file(dir, "*_lab-en.xml", true)
    @@xbrl         = get_presenters_file(dir, "*.xbrl")
  end

  def get_presenters_file(dir, pattern, hash_flag=false)
    Dir.chdir(dir)
    files = Dir.glob("XBRL/PublicDoc/**/#{pattern}")
    if hash_flag
      result = {}
      files.each do |file_name|
        result[file_name] = File.open(file_name) {|file| Nokogiri::XML file }
      end
    else
      result = File.open(files.first) {|file| Nokogiri::XML file }
    end

    return result
  end

  def get_edinet_files(xsd)
    @@label.store(*get_edinet_file(xsd, "_lab.xml"))
    @@label_en.store(*get_edinet_file(xsd, "_lab-en.xml"))
  end

  def get_edinet_file(xsd, pattern)
    xsd.xpath("//link:linkbaseRef[contains(./@xlink:href, '#{pattern}')]/@xlink:href").each do |href|
      if /^http\:\/\/disclosure\.edinet\-fsa\.go\.jp\/taxonomy\/jppfs\// =~ href
        return href, open(href) {|file| Nokogiri::XML file }
      end
    end
  end
end