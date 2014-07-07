# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ViewFileController do
  it 'should be possible to download a BasicFile' do
    file = create_basic_file(nil)

    get :show, :pid => file.pid
    response.status.should == 200
    puts response.header.inspect
    response.header['Content-Type'].should == file.mime_type
  end

  describe 'routing non-BasicFile' do
    it 'should not be possible to download AuthorityMetadataUnit' do
      amu = AuthorityMetadataUnit.create!(:type => 'agent/person', :value => 'agent name')

      get :show, :pid => amu.pid
      response.status.should == 302
      response.should redirect_to :root
    end

    it 'should not be possible to download AuthorityMetadataUnit' do
      work = Work.create!(:work_type => 'NOT A FILE', :title => 'name of work')

      get :show, :pid => work.pid
      response.status.should == 302
      response.should redirect_to :root
    end
  end
end