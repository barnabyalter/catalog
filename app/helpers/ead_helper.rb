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
    link_to(fields.join(", "), catalog_path(solr_doc[:id]), :class => "component_link")
  end

  def location_link(solr_doc)
    if solr_doc["location_display"]
      render_document_show_field_value(:document => solr_doc, :field => "location_display")
    end 
  end



end