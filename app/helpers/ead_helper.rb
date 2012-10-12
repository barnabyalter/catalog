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

  def component_link
    link_to(component_title, catalog_path(@child_doc[:id]), :class => "component_link")
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

  def component_trail result = String.new
    result << link_to(@document[:collection_display].first, catalog_path(@document[:eadid_s]), :class => "component_link")
    if @document[:parent_ids_display]
      @document[:parent_ids_display].each_index do |n|
        result << " >> "
        id = @document[:eadid_s] + ":" + @document[:parent_ids_display][n]
        result << link_to(@document[:parent_unittitles_display][n], catalog_path(id), :class => "component_link")
      end
    end
    result << " >> " + @document[:title_display]
    return result.html_safe
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
    if has_json?
      results << "<div id=\"ead_sidebar\">"
      results << toggle_view_link
      results << link_to("XML view", ead_xml_path, { :target => "_blank" })
      results << content_tag(:ul, ead_anchor_links, :id =>"ead_nav")
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