module LocalBlacklightHelper

  #
  # These methods override helper methods in the Blacklight gem
  #

  def application_name
    'Rock and Roll Hall of Fame and Museum | Library and Archives | Catalog'
  end

  # overrides app/helpers/blacklight/blacklight_helper_behavior.rb
  def render_document_heading
    render :partial => "catalog/rockhall_heading"
  end

  # overrides link_to_document to method to directly display the archival item within
  # the finding aid.
  def link_to_document(doc, opts={:label=>nil, :counter => nil, :results_view => true})
    label ||= blacklight_config.index.show_link.to_sym
    label = render_document_index_label doc, opts
    if doc[:format] == "Archival Item"
      url = catalog_path(doc.id) + "#" + doc.id.to_s
      link_to label, url
    else
      link_to label, doc, :'data-counter' => opts[:counter]
    end
  end

end