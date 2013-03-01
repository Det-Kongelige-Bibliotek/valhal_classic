# -*- encoding : utf-8 -*-
# ${PROJECT_NAME}
# File: basic_inheritance_spec.rb
# User: jolf
# Date: 2013-02-22
require 'spec_helper'

describe "The basic inheritance" do
  describe "for locating sub-elements" do
    before :all do
      pending "Other tests"
      class ParentClass < ActiveFedora::Base
        belongs_to :description, :class_name=>"DescriptionClass", :property=>:has_description, :inverse_of=>:is_description_of
      end
      class ChildClass < ParentClass
      end
      class DescriptionClass < ActiveFedora::Base
        has_many :parents, :class_name=>"ParentClass", :property=>:is_description_of, :inverse_of=>:has_description
      end
    end

    it "should be possible to locate a child from the parent class" do
      pending "Apparently it is not possible to locate a child class through the parent."

      child = ChildClass.create

      ParentClass.all.size.should == 1
      parent = ParentClass.find(child.pid)
      parent.pid.should == child.pid
    end

    it "should be possible to add a parent to the description" do
      dc = DescriptionClass.create
      parent = ParentClass.create

      dc.parents << parent
      dc.save!

      dc.parents.size.should == 1
      dc.parents.first.should == parent
    end

    it "should also be added to the parent" do
      pending "Apparently this does not work..."
      dc = DescriptionClass.create
      parent = ParentClass.create

      dc.parents << parent
      dc.save!

      parent.description.should_not be_nil
      parent.description.should == dc
    end

    it "should have a parent with parent class" do
      dc = DescriptionClass.create
      parent = ParentClass.create

      dc.parents << parent
      dc.save!

      dc.parents.size.should == 1
      dc.parents.first.class.name.should == ParentClass.name
    end

    it "should be possible to add a child to the description" do
      dc = DescriptionClass.create
      child = ChildClass.create

      dc.parents << child
      dc.save!

      dc.parents.size.should == 1
      dc.parents.first.should == child
    end

    it "should also be added to the child" do
      pending "Apparently this does not work..."
      dc = DescriptionClass.create
      child = ChildClass.create

      dc.parents << child
      dc.save!

      child.description.should_not be_nil
      child.description.should == dc
    end

    it "should have a child with child class" do
      dc = DescriptionClass.create
      child = ChildClass.create

      dc.parents << child
      dc.save!

      dc.parents.size.should == 1
      dc.parents.first.class.name.should == ChildClass.name
    end

    it "should be possible to distinct a Child and a Parent" do
      dc = DescriptionClass.create
      child = ChildClass.create
      parent = ParentClass.create

      dc.parents << child
      dc.parents << parent
      dc.save!

      dc.parents.size.should == 2
      dc.parents.first.class.name.should == ChildClass.name
      dc.parents.last.class.name.should == ParentClass.name

      puts dc.parents
      dc.parents.each { |p| puts p.class.name + " " + p.pid}

      puts dc.parents.class.name
      puts
    end
  end

  describe "for ActiveFedora the through attribute" do
    before :all do
      class Contribution < ActiveFedora::Base
        belongs_to :entity, :property => :is_part_of
        belongs_to :provider, :property => :is_part_of
      end

      class Provider < ActiveFedora::Base
        has_many :contributions, :property => :is_part_of
        has_many :entities, :through => :contributions, :property => :is_part_of
      end
      class Entity < ActiveFedora::Base
        has_many :contributions, :property => :is_part_of
        has_many :providers, :through => :contributions, :property => :is_part_of
      end
    end

    it "should be accessible through the common object" do
      provider = Provider.create
      entity = Entity.create
      contribution = Contribution.create

      contribution.entity = entity
      contribution.provider = provider
      contribution.save!
      entity.contributions << contribution
      provider.contributions << contribution
      entity.save!
      provider.save!

      entity.contributions.should_not be_nil
      entity.contributions.should_not be_empty
      entity.contributions.length.should == 1
      entity.contributions.should == [contribution]

      contribution.entity.should_not be_nil
      contribution.entity.should == entity

      contribution.provider.should_not be_nil
      contribution.provider.should == provider

      provider.contributions.should_not be_nil
      provider.contributions.should_not be_empty
      provider.contributions.length.should == 1
      provider.contributions.should == [contribution]

      entity.providers.should_not be_nil
      entity.providers.should_not be_empty
      entity.providers.length.should == 1
      entity.providers.should == [provider]

      provider.entities.should_not be_nil
      provider.entities.should_not be_empty
      provider.entities.length.should == 1
      provider.entities.should == [entity]

    end
  end

  describe "for ActiveRecord the through attribute" do
    before :all do
      pending ""
      class Contribution < ActiveRecord::Base
        belongs_to :entity
        belongs_to :provider
      end

      class Provider < ActiveRecord::Base
        has_many :contributions
        has_many :entities, :through => :contributions
      end
      class Entity < ActiveRecord::Base
        has_many :contributions
        has_many :providers, :through => :contributions
      end
    end

    it "should be accessible through the common object" do
      provider = Provider.create
      entity = Entity.create
      contribution = Contribution.create

      contribution.entity = entity
      contribution.provider = provider
      contribution.save!
      entity.contributions << contribution
      provider.contributions << contribution
      entity.save!
      provider.save!

      entity.contributions.should_not be_nil
      entity.contributions.should_not be_empty
      entity.contributions.length.should == 1
      entity.contributions.should == [contribution]

      contribution.entity.should_not be_nil
      contribution.entity.should == entity

      contribution.provider.should_not be_nil
      contribution.provider.should == provider

      provider.contributions.should_not be_nil
      provider.contributions.should_not be_empty
      provider.contributions.length.should == 1
      provider.contributions.should == [contribution]

      entity.providers.should_not be_nil
      entity.providers.should_not be_empty
      entity.providers.length.should == 1
      entity.providers.should == [provider]

      provider.entities.should_not be_nil
      provider.entities.should_not be_empty
      provider.entities.length.should == 1
      provider.entities.should == [entity]

    end
  end
end
