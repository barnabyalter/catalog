module Rockhall::ControllerBehaviors

  def query_child_components
    id, ref = params[:id].split(/:/)
    unless ref.nil?
      @children = additional_ead_components(id,ref)
    end
  end

  def additional_ead_components(id,ref, solr_params = Hash.new)
    solr_params[:fl]   = "id"
    solr_params[:q]    = "parent_id_s:#{ref} AND eadid_s:#{id}"
    solr_params[:sort] = "sort_i asc"
    solr_params[:qt]   = "standard"
    solr_params[:rows] = 10000
    solr_response = Blacklight.solr.find(solr_params)
    list = solr_response.docs.collect {|doc| SolrDocument.new(doc, solr_response)}

    docs = Array.new
    list.each do |doc|
      r, d = get_solr_response_for_doc_id(doc.id)
      docs << d
    end
    return docs
  end

  def ead_xml
    file = File.join(Rails.root, Rails.configuration.rockhall_config[:ead_path], (params[:id] + ".xml"))
    if File.exists?(file)
      render :file => file 
    else
      flash[:notice] = "XML file for #{params[:id]} was not found or is unavailable"
      redirect_to root_path
    end
  end
end