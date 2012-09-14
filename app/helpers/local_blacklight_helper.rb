# Overrides methods found in the Blacklight gem under:
#
#  app/helpers/blacklight/blacklight_helper_behavior.rb
#
module LocalBlacklightHelper

  def application_name
    'Rock and Roll Hall of Fame and Museum | Library and Archives | Catalog'
  end

  def render_document_show_field_value args
    value = args[:value]
    value ||= args[:document].get(args[:field], :sep => nil) if args[:document] and args[:field]
    if Rails.configuration.rockhall_config[:linked_fields].keys.include?(args[:field].to_sym)
      render_field_link args
    elsif Rails.configuration.rockhall_config[:external_links].include?(args[:field])
      render_external_link args
    else
      render_field_value value
    end
  end

  def document_heading
    if @document["format"] == "Archival Item"
      component_trail(@document)
    else
      @document[blacklight_config.show.heading] || @document.id
    end
  end
  
  def render_document_heading
    render :partial => "catalog/rockhall_heading"
  end

  # overrides link_to_document to method to directly display the archival item within
  # the finding aid.
  #
  # DEPRECATED
  def deprecated_link_to_document(doc, opts={:label=>nil, :counter => nil, :results_view => true})
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