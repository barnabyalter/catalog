require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rockhall::Innovative do

  describe "#get_holdings" do

    it "should return a partial html table with holdings information" do
      Rails.configuration.rockhall_config[:opac_ip] = "129.22.104.30"
      status = Rockhall::Innovative.get_holdings("b3386820")
      status.should be_a_kind_of(Array)
      status.each do |html|
        html.should be_a_kind_of(String)
        html.should match(/<td>/)
      end
    end

    it "should return 'unknown' for non-existent items" do
      Rails.configuration.rockhall_config[:opac_ip] = "0.0.0.0"
      status = Rockhall::Innovative.get_holdings("b3386820")
      status.first.should == 'unknown'
    end

    it "should return 'unknown if the host is down" do
      Rails.configuration.rockhall_config[:opac_ip] = "1.2.3.4"
      status = Rockhall::Innovative.get_holdings("b3386820")
      status.first.should == 'unknown'
    end

  end

  describe "#query_iii" do

    it "should return the html document from III's opac" do
      Rails.configuration.rockhall_config[:opac_ip] = "129.22.104.30"
      html = Rockhall::Innovative.query_iii("b3311377")
      html.should be_a_kind_of(Nokogiri::HTML::Document)
    end

    it "should return return null if the host is down" do
      Rails.configuration.rockhall_config[:opac_ip] = "1.2.3.4"
      html = Rockhall::Innovative.query_iii("b3311377")
      html.should be_nil

    end

  end

  describe "#link" do
    it "should return a url for a given id" do
      Rails.configuration.rockhall_config[:opac_ip] = "0.0.0.0"
      link = Rockhall::Innovative.link("foo")
      link.should == "http://0.0.0.0/record=foo"
    end
  end

end