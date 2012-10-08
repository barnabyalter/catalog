require "nokogiri"

# These are class methods used when indexing ead xml into solr.
module Rockhall::Indexing

  # Converts an ead xml file into two html files.  One is for the the default display in
  # Blacklight, which is just the archdesc section of the ead.  The second html file is
  # for the optional display of the entire finding aid.
  def self.ead_to_html(file)
    self.default_html(file)
    self.full_html(file)
  end

  def self.default_html(file)
    xsl_file = File.join(Rails.root, "xsl", "ead_to_html.xsl")
    xsl = Nokogiri::XSLT(File.read(xsl_file))
    html = Nokogiri(File.read(file))
    dst = File.join(Rails.root, "public", "fa", File.basename(file)).gsub(/\.xml$/,".html")
    File.open(dst, "w") { |f| f << cleanup_xml(xsl.apply_to(html).to_s) }
  end

  def self.full_html(file)
    xsl_file = File.join(Rails.root, "xsl", "ead_to_html_full.xsl")
    xsl = Nokogiri::XSLT(File.read(xsl_file))
    html = Nokogiri(File.read(file))
    dst = File.join(Rails.root, "public", "fa", File.basename(file)).gsub(/\.xml$/,"_full.html")
    File.open(dst, "w") { |f| f << cleanup_xml(xsl.apply_to(html).to_s) }
  end

  # AT's process of exporting ead xml sometimes creates some bad characters.  We need
  # to convert them here.
  def self.cleanup_xml(results)
    results.gsub!(/<title/,"<span")
    results.gsub!(/<\/title/,"</span")
    results.gsub!(/&lt;title/,"<span")
    results.gsub!(/&lt;\/title/,"</span")
    results.gsub!(/&gt;/,">")
    results.gsub!(/render=/,"class=")
    if ENV['RAILS_RELATIVE_URL_ROOT']
      results.gsub!(/RAILS_RELATIVE_URL_ROOT/,ENV['RAILS_RELATIVE_URL_ROOT'])
    else
      results.gsub!(/RAILS_RELATIVE_URL_ROOT/,"")
    end
    return results
  end

  # Writes a json file for the table of contents using what's in solr.  Used by JSTree
  # to navigate the collection inventory.
  #
  # Uses the CollectionTree to reassemble each component into its correct hierarchy.
  def self.toc_to_json(id)
    inventory = Rockhall::CollectionInventory.new(id)
    unless inventory.tree.empty?
      toc_dst = File.join(Rails.root, "public", "fa", (id + "_toc.json"))
      File.open(toc_dst, "w") { |f| f << inventory.tree.to_json }
    end
  end


end