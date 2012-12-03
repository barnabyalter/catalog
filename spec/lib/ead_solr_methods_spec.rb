require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rockhall::EadSolrMethods do

  include Rockhall::EadSolrMethods

  describe ".get_field_from_solr" do
    it "should return the ead_id for a given component id" do
      get_field_from_solr("eadid_s","ARC-0065ref61").should == "ARC-0065"
    end

    it "should return nil given a non-existant field from an existing doc" do
      get_field_from_solr("foo","ARC-0065ref61").should be_nil
    end

    it "should return nil given a non-existant doc" do
      get_field_from_solr("foo","bar").should be_nil
    end

    it "should return a list of parent references for a given component id" do
      get_field_from_solr("parent_ids_display","ARC-0065ref61").should == ["ref42"]
      get_field_from_solr("parent_id_s","ARC-0065ref61").should        == "ref42"
    end
  end

  describe ".get_component_docs_from_solr" do
    it "should return an array component documents given an ead id and a level" do
      get_component_docs_from_solr("ARC-0065", { :level => "1"}).should == ["ARC-0065ref42", "ARC-0065ref43"]
      get_component_docs_from_solr("ARC-0005", { :level => "2"}).should include("ARC-0005ref62", "ARC-0005ref63", "ARC-0005ref64")
    end

    it "should return an array component documents given a parent id" do
      docs = get_component_docs_from_solr("ARC-0005", { :parent_id_s => "ref19"})
      docs.length.should == 7
      docs.first.should  == "ARC-0005ref138"
      docs.last.should   == "ARC-0005ref144"
    end
  end

end