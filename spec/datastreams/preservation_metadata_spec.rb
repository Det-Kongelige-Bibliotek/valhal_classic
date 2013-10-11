# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Datastreams::PreservationDatastream do
  describe 'as default' do
    it 'should have the xml structure as default' do
      xml_format = Datastreams::PreservationDatastream.xml_template
      xml_format.should_not be_nil
      xml_format.to_s.should include "fields"
    end
  end

  describe 'containing data' do
    it 'should be inserted into the xml' do
      pd = Datastreams::PreservationDatastream.new
      pd.preservation_profile = "N/A"
      pd.preservation_state = "N/A"
      pd.preservation_details = "N/A"
      pd.preservation_modify_date = "N/A"
      pd.preservation_comment = "N/A"

      xml = pd.to_xml
      xml.should_not be_nil
      xml.to_s.should include "fields"
      xml.to_s.should include "<preservation_profile>"
      xml.to_s.should include "<preservation_state>"
      xml.to_s.should include "<preservation_details>"
      xml.to_s.should include "<preservation_modify_date>"
      xml.to_s.should include "<preservation_comment>"
    end
  end

end