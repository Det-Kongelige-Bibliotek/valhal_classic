require 'spec_helper'

describe 'GenericFile' do

  it 'should retrieve a file using a FileDetails object' do

    file = add_file_from_server('programming-ruby-1-9-2-0_p1_0.pdf')
    file.should_not be_nil
  end
end