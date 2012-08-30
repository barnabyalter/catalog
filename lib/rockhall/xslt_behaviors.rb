require "nokogiri"

module Rockhall::XsltBehaviors

  def self.ead_to_html(file)
    xsl_file = File.join(Rails.root, "xsl", "ead_to_html.xsl")
    xsl = Nokogiri::XSLT(File.read(xsl_file))
    html = Nokogiri(File.read(file))
    dst = File.join(Rails.root, "public", "fa", File.basename(file)).gsub(/\.xml$/,".html")
    File.open(dst, "w") { |f| f << cleanup_xml(xsl.apply_to(html).to_s) }
  end

  def self.cleanup_xml(results)
    results.gsub!(/<title/,"<span")
    results.gsub!(/<\/title/,"</span")
    results.gsub!(/&lt;title/,"<span")
    results.gsub!(/&lt;\/title/,"</span")
    results.gsub!(/&gt;/,">")
    results.gsub!(/render=/,"class=")
    return results
  end



end