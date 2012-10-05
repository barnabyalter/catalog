module EadHelper

  def toggle_view_link
    if params["view"] == "full"
      link_to("Default view", catalog_path(params[:id]))
    else
      if params[:id].match(/:/)
        link_to("Full view", catalog_path(@document["eadid_s"], :view=>"full", :anchor => params[:id].split(/:/).last))
      else
        link_to("Full view", catalog_path(params[:id], :view=>"full"))
      end
    end
  end

  def component_link(solr_doc)
    fields = [render_document_show_field_value(:document => solr_doc, :field => "title_display"), render_document_show_field_value(:document => solr_doc, :field => "unitdate_display")]
    fields.reject! { |c| c.empty? }
    if solr_doc["component_children_b"]
      link_to(fields.join(", "), catalog_path(solr_doc[:id]), :class => "component_link")
    else
      fields.join(", ")
    end 
  end

  def location_link(solr_doc)
    if solr_doc["location_display"]
      render_document_show_field_value(:document => solr_doc, :field => "location_display")
    end 
  end

  def component_trail(solr_doc, result=String.new)
    result << link_to(solr_doc["collection_display"].first, catalog_path(solr_doc["eadid_s"]), :class => "component_link")
    if solr_doc["parent_ids_display"]
      solr_doc["parent_ids_display"].each_index do |n|
        result << " >> "
        id = solr_doc["eadid_s"] + ":" + solr_doc["parent_ids_display"][n]
        result << link_to(solr_doc["parent_unittitles_display"][n], catalog_path(id), :class => "component_link")
      end
    end
    result << " >> " + solr_doc["title_display"]
    return result.html_safe
  end

  def render_component_children results = String.new
    results << "<table>"
    @children.each do |child|
      results << "<tr><td>"
      results << component_link(child)
      results << "</td><td>"
      results << location_link(child) unless location_link(child).nil?
      results << "</td></tr>"
    end
    results << "</table>"
    return results.html_safe
  end

end