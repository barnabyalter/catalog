require "nokogiri"

module Rockhall::XsltBehaviors

  def self.ead_to_html(file)
    xsl_file = File.join(Rails.root, "xsl", "ead_to_html.xsl")
    xsl = Nokogiri::XSLT(File.read(xsl_file))
    html = Nokogiri(File.read(file))
    name = "_" + File.basename(file).gsub(/\..*$/,"").gsub(/-/,"_").downcase
    dst = File.join(Rails.root, "public", "fa", name)
    File.open(dst, "w") { |f| f << xsl.apply_to(html).to_s }
  end



end