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




end