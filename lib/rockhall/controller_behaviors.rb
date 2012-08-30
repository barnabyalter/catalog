module Rockhall::ControllerBehaviors

  def redirect_component_documents
    id, ref = request.parameters["id"].split(/:/)
    redirect_to catalog_path(id, {:anchor => ref}) unless ref.nil?
  end

end