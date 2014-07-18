# -*- encoding : utf-8 -*-
require 'spec_helper'

describe InstanceHelper do
  before(:each) do
    @instance = SingleFileInstance.create
  end

  it 'should fail' do
    add_agents(@instance, nil)
  end
end
