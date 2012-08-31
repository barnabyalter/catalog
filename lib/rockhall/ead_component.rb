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
      t.label(:path=>{ :attribute=>"label" }, :index_as => [:facetable])
    }
    t.material(:proxy=>[:container, :label])

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
    }
    t.container_label(:proxy=>[:container, :label])
    t.container_type(:proxy=>[:container, :type])

    # <odd> nodes
    # These guys depend on what's in <head> so we do some xpathy stuff...
    t.general_note(:path=>'odd[./head="General note"]/p')
    t.accession(:path=>'odd[./head="Museum Accession Number"]/p', :index_as => [:not_searchable, :string])


  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"xml_display"     => self.to_xml})
    solr_doc.merge!({"format"          => "Archival Item"})
    solr_doc.merge!({"heading_display" => [ solr_doc["parent_unittitles_display"], self.title.first ].join(" >> ")  })

    # Assemble location_display
    locations = Array.new
    self.container_type.each_index do |i|
      locations << self.container_type[i] + ": " + self.container[i]
    end
    solr_doc.merge!({"location_display" => locations.join(", ")})

    # Build accession ranges
    solr_doc.merge!({"accession_t" => ead_accession_range(self.accession.first)})

  end

end