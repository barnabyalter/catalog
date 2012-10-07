# Rockhall::CollectionTree returns a nested array that represents series and subseries
# components.  The array conforms to the JSTree format.

module Rockhall
class CollectionInventory

  attr_accessor :id, :tree

  def initialize(id)
    @id   = id
    @tree =  add_first_level
    #add_series
  end

  def add_series
    self.tree = add_first_level
    add_second_level
    #add_third_level
  end

  def add_first_level(node = Array.new)
    solr_query.each do |series|
      node << { "data" => series["title_display"], "metadata" => { "id" => series["id"], "ref" => series["ref_s"], "eadid" => series["eadid_s"] }}
    end
    return node
  end

  def add_second_level
    self.tree.each do |parent|
      node = Array.new
      solr_query({:parent => parent["metadata"]["id"].split(/:/).last}).each do |series|
        node << { "data" => series["title_display"], "metadata" => { "id" => series["id"], "ref" => series["ref_s"], "eadid" => series["eadid_s"] }}
      end
      parent["children"] = node
    end
  end

  def add_third_level
    self.tree.each do |level1|
      level1["children"].each do |level2|
        level2["children"].each do |parent|
          node = Array.new
          solr_query({:parent => parent["metadata"]["id"].split(/:/).last}).each do |series|
            node << { "data" => series["title_display"], "metadata" => { "id" => series["id"], "ref" => series["ref_s"], "eadid" => series["eadid_s"] }}
          end
          parent["children"] = node
        end
      end
    end
  end

  def solr_query(opts={}, query = Hash.new)
    if opts[:parent]
      query[:q] = 'eadid_s:"' + @id + '" AND component_children_b:TRUE AND parent_id_s:"' + opts[:parent] + '"'
    else
      query[:q] = 'eadid_s:"' + @id + '" AND component_children_b:TRUE AND component_level_i:1'
    end
    query[:fl]   = 'id, component_level_i, parent_id_s, title_display, ref_s, eadid_s'
    query[:qt]   = 'document'
    query[:rows] = 10000
    Blacklight.solr.find(query)["response"]["docs"].collect { |doc| doc }
  end


end
end