module EadHelper

  def toggle_view_link link = String.new
    if params["view"] == "full"
      link << link_to("Default view", catalog_path(params[:id]))
    else
      if @document[:ref_s]
        link << link_to("Full view", catalog_path(@document["eadid_s"], :view=>"full", :anchor => @document[:ref_s]))
      else
        link << link_to("Full view", catalog_path(params[:id], :view=>"full"))
      end
    end
    return ("<div id=\"view_toggle\">" + link + "</div>").html_safe
  end

  def component_link
    link_to(component_title, catalog_path(@child_doc[:id]), :class => "component_link", :id => @child_doc[:id])
  end

  def component_title
    fields = [render_document_show_field_value(:document => @child_doc, :field => "title_display"), render_document_show_field_value(:document => @child_doc, :field => "unitdate_display")]
    fields.reject! { |c| c.empty? }
    fields.join(", ")
  end

  def location_link
    if @child_doc["location_display"]
      render_document_show_field_value(:document => @child_doc, :field => "location_display")
    else
      return ""
    end 
  end

  def component_trail trail = Array.new
    trail << trail_link(@document[:collection_display].first, @document[:eadid_s])
    if @document[:parent_ids_display]
      @document[:parent_ids_display].each_index do |n|
        trail << trail_link(@document[:parent_unittitles_display][n], (@document[:eadid_s] + @document[:parent_ids_display][n]))
      end
    end
    if  @document[:title_display]
      trail << @document[:title_display]
    elsif @document[:unitdate_display]
      trail << @document[:unitdate_display].first
    else
      trail << "[No title]"
    end
    return trail.join(" >> ").html_safe
  end

  def trail_link text, id
    if id == @document[:eadid_s]
      link_to(text, catalog_path(id), :class => "component_link")
    else
      link_to(text, catalog_path(id), :class => "component_link", :id => id)
    end
    
  end

  def render_component_children results = String.new
    results << "<table>"
    @children.each_index do |index|
      @child_doc = @children[index]
      index.odd? ? results << "<tr class=\"odd\">" : results << "<tr>"
      if @children[index][:component_children_b]
        results << "<td colspan=\"2\">" + component_link + "</td>"
      else
        results << "<td>" + component_title + "</td>"
        results << "<td class=\"nowrap\">" + location_link + "</td>"
      end
      results << "</tr>"
    end
    results << "</table>"
    return results.html_safe
  end

  def render_ead_sidebar results = String.new
    results << "<div id=\"ead_sidebar\">"
    results << toggle_view_link if has_json?
    results << link_to("XML view", ead_xml_path(@document[:eadid_s]), { :target => "_blank" })
    results << content_tag(:ul, ead_anchor_links, :id =>"ead_nav")
    if has_json?
      results << "<h5>Collection Inventory</h5>"
      results << "<div id=\"" + @document[:eadid_s] + "_toc\" class=\"ead_toc\"></div>"
    end
    return results.html_safe
  end

  def ead_anchor_links results = String.new
    links = [
      "custodhist_label_z",
      "userestrict_label_z",
      "abstract_label_z",
      "bioghist_label_z",
      "accruals_label_z",
      "separatedmaterial_label_z",
      "relatedmaterial_label_z",
    ]
    results << content_tag(:li, link_to("General Information", catalog_path(params[:id], :anchor => "geninfo"), :class => "ead_anchor"))
    links.each do |field|
      anchor = field.split(/_/).first
      unless @document[field.to_sym].nil?
        results << content_tag(:li, link_to(@document[field.to_sym], catalog_path(params[:id], :anchor => anchor), :class => "ead_anchor"))
      end
    end
    results << content_tag(:li, link_to("Subject Headings", catalog_path(params[:id], :anchor => "subjects"), :class => "ead_anchor"))
    unless has_json?
      results << content_tag(:li, link_to("Collection Inventory", catalog_path(params[:id], :anchor => "inventory"), :class => "ead_anchor"))
    end
    return  results.html_safe
  end

  def render_ead_html
    if params["view"] == "full" or !has_json?
      render :file => "#{Rails.root}/public/fa/#{@document[:eadid_s]}_full.html"
    else
      render :file => "#{Rails.root}/public/fa/#{@document[:eadid_s]}.html"
    end
  end

  def has_json?
   File.exists?(File.join(Rails.root, "public", "fa", (@document[:eadid_s] + "_toc.json"))) unless @document[:eadid_s].nil?
  end

end