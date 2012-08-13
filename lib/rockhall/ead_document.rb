class Rockhall::EadDocument < SolrEad::Document

  include Rockhall::EadBehaviors

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    t.root(:path=>"ead", :index_as => [:not_searchable])

    t.eadid(:index_as=>[:not_searchable, :string])
    t.corpname(:index_as=>[:facetable])
    t.famname(:index_as=>[:facetable])
    t.genreform(:index_as=>[:facetable])
    t.geogname(:index_as=>[:facetable])
    t.name(:index_as=>[:facetable])
    t.persname(:index_as=>[:facetable])
    t.subject(:index_as=>[:facetable])

    # These terms are proxied to match with Blacklight's default facets, but otherwise
    # you can remove them or rename the above facet terms to match with your solr
    # implementation.
    t.subject_geo(:proxy=>[:geogname])
    t.subject_topic(:proxy=>[:subject])

    t.italic(:path=>"/*/title", :attributes => { :render=>"italic" })

    t.title(:path=>"titleproper", :attributes=>{ :type => :none }, :index_as=>[:searchable])
    t.title_num(:path=>"titleproper/num", :attributes=>{ :type => :none }, :index_as=>[:string, :not_searchable])
    t.title_filing(:path=>"titleproper", :attributes=>{ :type => "filing" }, :index_as=>[:not_searchable, :string, :sortable])
    t.extent(:path=>"archdesc/did/physdesc/extent")
    t.unitdate(:path=>"archdesc/did/unitdate[not(@type)]")
    t.unitdate_bulk(:path=>"archdesc/did/unitdate[@type='bulk']")
    t.unitdate_inclusive(:path=>"archdesc/did/unitdate[@type='inclusive']")
    t.langmaterial(:path=>"archdesc/did/langmaterial", :index_as=>[:string, :not_searchable])
    t.langusage(:path=>"eadheader/profiledesc/langusage", :index_as=>[:string, :not_searchable])
    t.abstract(:path=>"archdesc/did/abstract") {
      t.label(:path => {:attribute=>"label"}, :index_as=>[:not_searchable, :z])
    }

    t.collection(:path=>"archdesc/did/unittitle", :index_as=>[:facetable, :displayable, :searchable])

    # Biography/History section
    t.bioghist {
      t.head
      t.cronlist
      t.p
    }

    # General field available within archdesc
    t.accessrestrict(:path=>"archdesc/accessrestrict/p")
    t.accessrestrict_label(:path=>"archdesc/accessrestrict/head", :index_as=>[:not_searchable, :z])
    t.accruals(:path=>"archdesc/accruals/p")
    t.accruals_label(:path=>"archdesc/accruals/head", :index_as=>[:not_searchable, :z])
    t.acqinfo(:path=>"archdesc/acqinfo/p")
    t.acqinfo_label(:path=>"archdesc/acqinfo/head", :index_as=>[:not_searchable, :z])
    t.altformavail(:path=>"archdesc/altformavail/p")
    t.altformavail_label(:path=>"archdesc/altformavail/head", :index_as=>[:not_searchable, :z])
    t.appraisal(:path=>"archdesc/appraisal/p")
    t.appraisal_label(:path=>"archdesc/appraisal/head", :index_as=>[:not_searchable, :z])
    t.arrangement(:path=>"archdesc/arrangement/p")
    t.arrangement_label(:path=>"archdesc/arrangement/head", :index_as=>[:not_searchable, :z])
    t.custodhist(:path=>"archdesc/custodhist/p")
    t.custodhist_label(:path=>"archdesc/custodhist/head", :index_as=>[:not_searchable, :z])
    t.fileplan(:path=>"archdesc/fileplan/p")
    t.fileplan_label(:path=>"archdesc/fileplan/head", :index_as=>[:not_searchable, :z])
    t.originalsloc(:path=>"archdesc/originalsloc/p")
    t.originalsloc_label(:path=>"archdesc/originalsloc/head", :index_as=>[:not_searchable, :z])
    t.phystech(:path=>"archdesc/phystech/p")
    t.phystech_label(:path=>"archdesc/phystech/head", :index_as=>[:not_searchable, :z])
    t.processinfo(:path=>"archdesc/processinfo/p")
    t.processinfo_label(:path=>"archdesc/processinfo/head", :index_as=>[:not_searchable, :z])
    t.prefercite(:path=>"archdesc/prefercite/p")
    t.prefercite_label(:path=>"archdesc/prefercite/head", :index_as=>[:not_searchable, :z])
    t.relatedmaterial(:path=>"archdesc/relatedmaterial/p")
    t.relatedmaterial_label(:path=>"archdesc/relatedmaterial/head", :index_as=>[:not_searchable, :z])
    t.separatedmaterial(:path=>"archdesc/separatedmaterial/p")
    t.separatedmaterial_label(:path=>"archdesc/separatedmaterial/head", :index_as=>[:not_searchable, :z])
    t.scopecontent(:path=>"archdesc/scopecontent/p")
    t.scopecontent_label(:path=>"archdesc/scopecontent/head", :index_as=>[:not_searchable, :z])
    t.userestrict(:path=>"archdesc/userestrict/p")
    t.userestrict_label(:path=>"archdesc/userestrict/head", :index_as=>[:not_searchable, :z])

  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    #solr_doc.merge!({"id"                => self.eadid.first})
    #solr_doc.merge!({"eadid_s"           => self.eadid.first})
    #solr_doc.merge!({"xml_s"             => self.to_xml})
    solr_doc.merge!({"format"            => "Archival Collection"})
    solr_doc.merge!({"heading_display"   => ("Guide to the " + self.title.first.gsub!(self.title_num.first,"").strip)})
    solr_doc.merge!({"unitdate_z"        => ead_date_display})

    # *_heading is dynamic un-indexed, single string... it's a bit misleading and should be changed

    return solr_doc
  end

end