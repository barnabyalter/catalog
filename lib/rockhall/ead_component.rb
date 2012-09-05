class Rockhall::EadComponent < SolrEad::Component

  include Rockhall::EadBehaviors

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    t.root(:path=>"c", :index_as => [:not_searchable, :not_displayable])
    t.ref(:path=>"/c/@id", :index_as => [:not_searchable, :string])
    t.level(:path=>"/c/@level", :index_as => [:facetable, :not_searchable])

    t.title(:path=>"unittitle", :attributes=>{ :type => :none }, :index_as=>[:searchable, :displayable])
    t.unitdate(:index_as=>[:searchable, :displayable])

    # Default facets
    t.corpname(:index_as=>[:facetable])
    t.famname(:index_as=>[:facetable])
    t.genreform(:index_as=>[:facetable])
    t.geogname(:index_as=>[:facetable])
    t.name(:index_as=>[:facetable])
    t.persname(:index_as=>[:facetable])
    t.subject(:index_as=>[:facetable])

    # Archival material
    t.container(:attributes=>{ :type => "Box" }, :index_as => [:not_searchable, :not_displayable]) {
      t.label(:path=>{ :attribute=>"label" })
    }
    t.material(:proxy=>[:container, :label], :index_as => [:facetable])

    # These terms are proxied to match with Blacklight's default facets, but otherwise
    # you can remove them or rename the above facet terms to match with your solr
    # implementation.
    t.subject_geo(:proxy=>[:geogname])
    t.subject_topic(:proxy=>[:subject])

    t.accessrestrict(:path=>"accessrestrict/p")
    t.accessrestrict_label(:path=>"accessrestrict/head", :index_as=>[:not_searchable, :z])
    t.accruals(:path=>"accruals/p")
    t.accruals_label(:path=>"accruals/head", :index_as=>[:not_searchable, :z])
    t.acqinfo(:path=>"acqinfo/p")
    t.acqinfo_label(:path=>"acqinfo/head", :index_as=>[:not_searchable, :z])
    t.altformavail(:path=>"altformavail/p")
    t.altformavail_label(:path=>"altformavail/head", :index_as=>[:not_searchable, :z])
    t.appraisal(:path=>"appraisal/p")
    t.appraisal_label(:path=>"appraisal/head", :index_as=>[:not_searchable, :z])
    t.arrangement(:path=>"arrangement/p")
    t.arrangement_label(:path=>"arrangement/head", :index_as=>[:not_searchable, :z])
    t.custodhist(:path=>"custodhist/p")
    t.custodhist_label(:path=>"custodhist/head", :index_as=>[:not_searchable, :z])
    t.fileplan(:path=>"fileplan/p")
    t.fileplan_label(:path=>"fileplan/head", :index_as=>[:not_searchable, :z])

    t.originalsloc(:path=>"originalsloc/p")
    t.originalsloc_label(:path=>"originalsloc/head", :index_as=>[:not_searchable, :z])
    t.phystech(:path=>"phystech/p")
    t.phystech_label(:path=>"phystech/head", :index_as=>[:not_searchable, :z])
    t.processinfo(:path=>"processinfo/p")
    t.processinfo_label(:path=>"processinfo/head", :index_as=>[:not_searchable, :z])
    t.relatedmaterial(:path=>"relatedmaterial/p")
    t.relatedmaterial_label(:path=>"relatedmaterial/head", :index_as=>[:not_searchable, :z])
    t.separatedmaterial(:path=>"separatedmaterial/p")
    t.separatedmaterial_label(:path=>"separatedmaterial/head", :index_as=>[:not_searchable, :z])
    t.scopecontent(:path=>"scopecontent/p")
    t.scopecontent_label(:path=>"scopecontent/head", :index_as=>[:not_searchable, :z])
    t.userestrict(:path=>"userestrict/p")
    t.userestrict_label(:path=>"userestrict/head", :index_as=>[:not_searchable, :z])

    t.physdesc(:path=>"did/physdesc[not(dimensions)]")
    t.dimensions(:path=>"did/physdesc/dimensions")
    t.langmaterial(:path=>"did/langmaterial")

    t.container {
      t.label(:path => {:attribute=>"label"})
      t.type(:path => {:attribute=>"type"})
      t.id(:path => {:attribute=>"id"})
    }
    t.container_label(:proxy=>[:container, :label])
    t.container_type(:proxy=>[:container, :type])
    t.container_id(:proxy=>[:container, :id])

    # <odd> nodes
    # These guys depend on what's in <head> so we do some xpathy stuff...
    t.general_note(:path=>'odd[./head="General note"]/p')
    t.accession(:path=>'odd[./head[starts-with(.,"Museum Accession")]]/p', :index_as => [:not_searchable, :string])


  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"xml_display"        => self.to_xml})
    solr_doc.merge!({"format"             => "Archival Item"})
    solr_doc.merge!({"material_facet"     => self.material  })
    solr_doc.merge!({"location_display"   => self.location_display })
    solr_doc.merge!({"accession_t"        => ead_accession_range(self.accession.first)})
    solr_doc.merge!({"collection_display" => solr_doc["document_unittitle_display"] })
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