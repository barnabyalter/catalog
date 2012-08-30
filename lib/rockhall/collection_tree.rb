# Rockhall::CollectionTree returns a nested array that represents series and subseries
# components.  The array conforms to the JSTree format.

module Rockhall
class CollectionTree < Hash

  def initialize
    self["data"] ="Collection Inventory"
    self["metadata"] = { "anchor" => "#inventory" }
  end

  def add_series(id)
    @id = id
    add_first_level
    add_second_level
    add_third_level
  end

  def add_first_level(node = Array.new)
    solr_query.each do |series|
      node << { "data" => series["title_display"], "metadata" => { "anchor" => ("#"+series["id"].split(/:/).last) }}
    end
    self["children"] = node
  end

  def add_second_level
    self["children"].each do |parent|
      node = Array.new
      solr_query({:parent => parent["metadata"]["anchor"].gsub(/#/,"")}).each do |series|
        node << { "data" => series["title_display"], "metadata" => { "anchor" => ("#"+series["id"].split(/:/).last) }}
      end
      parent["children"] = node
    end
  end

  def add_third_level
    self["children"].each do |level2|
      level2["children"].each do |parent|
        node = Array.new
        solr_query({:parent => parent["metadata"]["anchor"].gsub(/#/,"")}).each do |series|
          node << { "data" => series["title_display"], "metadata" => { "anchor" => ("#"+series["id"].split(/:/).last) }}
        end
        parent["children"] = node
      end
    end
  end

  def solr_query(opts={}, query = Hash.new)
    if opts[:parent]
      query[:q] = 'eadid_s:"' + @id + '" AND component_children_b:TRUE AND parent_id_s:"' + opts[:parent] + '"'
    else
      query[:q] = 'eadid_s:"' + @id + '" AND component_children_b:TRUE AND component_level_i:1'
    end
    query[:fl]   = 'id, component_level_i, parent_id_s, title_display'
    query[:qt]   = 'document'
    query[:rows] = 10000
    Blacklight.solr.find(query)["response"]["docs"].collect { |doc| doc }
  end


end
end