class MyAuthor < ActiveFedora::Base

  has_metadata :name => 'descMetadata', :type => Datastreams::MyAdlTeiP5Datastream

end