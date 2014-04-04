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

  it 'should not be possible to download a non-BasicFile' do
    person = Person.create!(:firstname => 'firstname', :lastname => 'lastname', :date_of_birth => Time.now.nsec.to_s)

    get :show, :pid => person.pid
    response.status.should == 302
    response.should redirect_to :root
  end
end