class Rockhall::EadComponent < SolrEad::Component

  include Rockhall::EadBehaviors

  @terminology = SolrEad::Component.terminology

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)

    # Alter our heading display if the title is blank
    solr_doc["heading_display"] = (solr_doc["heading_display"] + self.unitdate.first) if self.title.first.blank?
    solr_doc.merge!({"location_display"        => self.location_display })
    solr_doc.merge!({"accession_unstem_search" => ead_accession_range(self.accession.first)})
    solr_doc.merge!({"text"                    => [self.title, solr_doc["parent_unittitles_display"]].flatten })
    solr_doc.merge!({"language_facet"          => get_language_from_code(self.langcode.first) })

  end

  def location_display(locations = Array.new)
    self.container_id.each do |id|
      line = String.new
      line << (self.find_by_xpath("//container[@id = '#{id}']/@type").text + ": ")
      line << self.find_by_xpath("//container[@id = '#{id}']").text
      sub_containers = Array.new
      self.find_by_xpath("//container[@parent = '#{id}']").each do |sub|
        sub_containers << sub.attribute("type").text + ": " + sub.text
      end
      line << (", " + sub_containers.join(", ") ) unless sub_containers.empty?
      line << " (" + self.find_by_xpath("//container[@id = '#{id}']/@label").text + ")"
      locations << line
    end
    return locations
  end

end