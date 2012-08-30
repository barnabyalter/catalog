require "nokogiri"

# These are class methods used when indexing ead xml into solr.
module Rockhall::Indexing

  # Converts an ead xml file into an html file for display in Blacklight
  def self.ead_to_html(file)
    xsl_file = File.join(Rails.root, "xsl", "ead_to_html.xsl")
    xsl = Nokogiri::XSLT(File.read(xsl_file))
    html = Nokogiri(File.read(file))
    dst = File.join(Rails.root, "public", "fa", File.basename(file)).gsub(/\.xml$/,".html")
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
    return results
  end

  # Writes a json file for the table of contents using what's in solr.  Used by JSTree
  # to navigate the collection inventory.
  #
  # Uses the CollectionTree to reassemble each component into its correct hierarchy.
  def self.toc_to_json(id, results = Array.new)

    doc_query = Hash.new
    doc_query[:q]    = 'id:"' + id + '"'
    doc_query[:qt]   = 'document'
    doc_query[:rows] = 1

    doc = Blacklight.solr.find(doc_query)["response"]["docs"].first

    results << { "data" => "Top" }
    [ "bioghist_label_z", "abstract_label_z", "relatedmaterial_label_z", "separatedmaterial_label_z", "accruals_label_z"].each do |label|
      results << { "data" => doc[label], "metadata" => { "anchor" => ("#" + label.split(/_/).first) }} unless doc[label].nil?
    end
    results << { "data" => "Subject Headings",     "metadata" => { "anchor" => "#subjects" }}

    collection = Rockhall::CollectionTree.new
    collection.add_series(id)
    results << collection

    toc_dst = File.join(Rails.root, "public", "fa", (id + "_toc.json"))
    File.open(toc_dst, "w") { |f| f << results.to_json }
  end


end