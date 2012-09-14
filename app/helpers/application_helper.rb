module ApplicationHelper

	def render_field_link args
    result = String.new
    search = Rails.configuration.rockhall_config[:linked_fields][args[:field].to_sym][:search]
    facet  = Rails.configuration.rockhall_config[:linked_fields][args[:field].to_sym][:facet]
    value = args[:value]
    value ||= args[:document].get(args[:field], :sep => nil) if args[:document] and args[:field]
    if value.is_a? Array
      value.each do |v|
        if facet
          result << link_to(v, add_facet_params_and_redirect(facet, v), :class=>"facet_select label")
          result << "<br/>"
        else
          result << link_to(v, catalog_index_path( :search_field => search, :q => "\"#{v}\"" ))
          result << field_value_separator
        end
      end
    else
      if facet
        result << link_to(v, add_facet_params_and_redirect(facet, v), :class=>"facet_select label")
      else
        result << link_to(value, catalog_index_path( :search_field => search, :q => "\"#{v}\"" ))
      end
    end
    return result.html_safe
  end

  def render_external_link args
    result = String.new
    value  = args[:value]
    text   = args[:document].get(Rails.configuration.rockhall_config[:external_links]["resource_link_display"])
    value ||= args[:document].get(args[:field], :sep => nil) if args[:document] and args[:field]
    result << link_to(text, value.first)
    return result.html_safe
  end

  def field_value_separator
    '<br/>'
  end

  def document_icon doc
    result = String.new
    if doc.get("format").nil?
      result << image_tag("icons/unknown.png")
    else
      filename = doc.get("format").downcase.gsub(/\s/,"_")
      result << image_tag("icons/#{filename}.png")
    end
    return result.html_safe
  end
  
end
