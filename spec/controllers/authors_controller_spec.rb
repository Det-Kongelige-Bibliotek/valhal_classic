# -*- encoding : utf-8 -*-
require 'spec_helper'

describe AuthorsController do

  describe "#new" do
    it "should be successful" do
      get :new
      assigns[:author].should be_kind_of Author
      response.should be_successful
    end
  end

  describe "#create" do
    before do
      Author.find_each { |a| a.delete }
      Author.count.should == 0
    end
    it "should allow to upload a tei file" do
      file = fixture_file_upload('/aarrebo_tei_p5_sample.xml', 'text/xml')
      stub_temp = double("Tempfile")
      content = File.open("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml", 'r:utf-8').read
      stub_temp.stub(:read).and_return(content)
      file.stub(:tempfile).and_return(stub_temp)
      post :create, :author => {:forename => "Alex", :surname => "Boesen", :upload => file}
      response.should redirect_to authors_index_path
      Author.count.should == 1
      string_from_fedora = Author.all.first.descMetadata.content
      # This ought to work, but the data comes back from fedora
      # without any encoding data, it's just a bytestream
      # string_from_fedora.should == content
      # Here's a workaround:
      #string_from_fedora.unpack('U*').pack('U*').should == content
      string_from_fedora.should be_equivalent_to content
    end
  end

end
