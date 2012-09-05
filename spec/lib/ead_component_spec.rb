require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rockhall::EadComponent do

  describe ".location_display" do

    it "should return an array of formatted locations" do
      xml = fixture "sample_component.xml"
      c = Rockhall::EadComponent.from_xml(xml)
      c.location_display.should include "Box: 5, Folder: 1, Object: 1-2 (Original Copy)"
    end

  end


end