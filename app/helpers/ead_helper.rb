module EadHelper

  def toggle_view_link link = String.new
    if params["view"] == "full"
      link << link_to("Default view", catalog_path(params[:id]))
    else
      if params[:id].match(/:/)
        link << link_to("Full view", catalog_path(@document["eadid_s"], :view=>"full", :anchor => params[:id].split(/:/).last))
      else
        link << link_to("Full view", catalog_path(params[:id], :view=>"full"))
      end
    end
    return ("<div id=\"view_toggle\">" + link + "</div>").html_safe
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

  def render_ead_sidebar results = String.new
    if @document[:eadid_s] and has_json?
      results << "<div id=\"ead_sidebar\">"
      results << toggle_view_link
      results << "<h5>Collection Inventory</h5>"
      results << "<div id=\"" + @document[:eadid_s] + "_toc\" class=\"ead_toc\"></div>"
    end
    return results.html_safe
  end

  def render_ead_html
    if params["view"] == "full" or !has_json?
      render :file => "#{Rails.root}/public/fa/#{@document[:eadid_s]}_full.html"
    else
      render :file => "#{Rails.root}/public/fa/#{@document[:eadid_s]}.html"
    end
  end

  def has_json?
    File.exists?(File.join(Rails.root, "public", "fa", (@document[:id] + "_toc.json")))
  end

end