module ComponentsHelper

  def parent_ead_id
    parts = params[:id].split(":")
    return parts[0]
  end

  def continue_components
    if @components.nil?
      next_component_button
    else
      if @components.has_key?(@document[:ref_s].to_sym)
        render :partial => "components/show", :locals => { :documents => @components[@document[:ref_s].to_sym] }
      else
        next_component_button
      end
    end
  end

  def next_component_button(results = String.new)
    if @document["component_children_b"]
      level = @document[:component_level_i].to_i + 1
      results << link_to( image_tag("icons/button_open.png", :alt => "+ Show"),
        components_path( :parent_ref => @document[:ref_s], :ead_id => @document[:eadid_s], :component_level => level ),
        :title => "Click to open",
        :id => "#{@document[:ref_s]}-switch",
        :remote => true,
        :onclick => "showWaiting('#{@document[:ref_t]}');")
    end
    return results.html_safe
  end

  def hide_component_button(results = String.new)
    if params[:component_level].to_i > 1
      results << link_to( image_tag("icons/button_close.png", :alt => "- Hide"),
        components_hide_path(:ead_id => params[:ead_id], :component_level => params[:component_level], :parent_ref => params["parent_ref"]),
        :title => "Click to close",
        :id => "#{params["parent_ref"]}-switch",
        :remote => true)
      results << "<div id=\"#{params[:parent_ref]}-list\">"
    end
    return results.html_safe
  end

  def render_component_field(field,opts={},results = String.new)
    label = opts[:label] ? opts[:label] : determine_label(field)
    unless @document[(field + "_t")].nil?
      results << "<dt>" + label + ":</dt>"
      results << "<dd><p>" + @document[(field + "_t")].join("</p><p>") + "</p></dd>"
    end
    return results.html_safe
  end

  def determine_label(field)
    @document[(field + "_label_heading")] ? @document[(field + "_label_heading")] : field.titleize
  end

  def highlight?(ref, results = String.new)
    if params[:solr_id]
      parts = params[:solr_id].split(":")
      if ref.to_s == parts.last.to_s
        results << 'style="background-color:yellow"'
      end
    end
    return results.html_safe
  end

end
