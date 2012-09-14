module Rockhall::ControllerBehaviors

  def query_child_components
    id, ref = params[:id].split(/:/)
    unless ref.nil?
      @children = additional_ead_components(ref)
    end
  end

  def additional_ead_components(ref, solr_params = Hash.new)
    solr_params[:fl]   = "id"
    solr_params[:q]    = "parent_id_s:#{ref}"
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

end