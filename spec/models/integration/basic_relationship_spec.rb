# -*- encoding : utf-8 -*-
# ${PROJECT_NAME}
# File: basic_relationship_spec.rb
# User: jolf
# Date: 2/8/13
require 'spec_helper'

describe "The basic relationships" do
  describe "for belongs_to and has_many" do
    before :all do
      #pending "Test other stuff"
    end

    describe "with same relational property" do
      before :all do
        class BelongsTo < ActiveFedora::Base
          belongs_to :hm, :class_name => "HasMany", :property => :is_part_of
        end
        class HasMany < ActiveFedora::Base
          has_many :bt, :class_name => "BelongsTo", :property => :is_part_of
        end
      end

      it "should not start with any relationships" do
        bt = BelongsTo.new
        hm = HasMany.new
        bt.hm.should be_nil
        hm.bt.should == []
      end

      it "should be possible to save the relationship directly on the 'belongs_to' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        bt.hm = hm
        bt.save.should == true
        bt.hm.should == hm
      end

      it "should be possible to save the relationship using the pids on the 'belongs_to' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        bt.hm_id = hm.pid
        bt.save!

        bt.hm.should == hm
        bt.hm_id.should == hm.pid
      end

      it "should be possible to find the related object on the 'belongs_to' object through the relationship predicate using the internal uri" do
        bt = BelongsTo.create
        hm = HasMany.create

        bt.hm = hm
        bt.save!

        bt.relationships(:is_part_of).should == [hm.internal_uri]
      end

      it "should the relationship be defined at both entities, when given to the 'belongs_to' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        bt.hm = hm
        bt.save!

        bt.hm.should == hm
        hm.bt.should == [bt]
      end

      it "should the relationship be expressed through the predicates of both entities, when given to the 'belongs_to' object" do
        pending "Cannot use the 'relationships' method on the 'has_many' relation"
        bt = BelongsTo.create
        hm = HasMany.create

        bt.hm = hm
        bt.save!

        bt.relationships(:is_part_of).should == [hm.internal_uri]
        hm.relationships(:is_part_of).should == [bt.internal_uri]
      end

      it "should be possible to save the relationship on the 'has_many' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        hm.bt << bt
        hm.save.should == true
        hm.bt.should == [bt]
      end

      it "should be possible to save the relationship using the pids on the 'has_many' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        hm.bt_ids = [bt.pid]
        hm.save!

        hm.bt.should == [bt]
        hm.bt_ids.should == [bt.pid]
      end

      it "should be possible to find the related object on the 'has_many' object through the relationship predicate using the internal uri" do
        pending "Cannot use the 'relationships' method on the 'has_many' relation"
        bt = BelongsTo.create
        hm = HasMany.create

        hm.bt << bt
        hm.save!

        hm.relationships(:is_part_of).should == [bt.internal_uri]
      end

      it "should the relationship be defined at both entities, when given to the 'has_many' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        hm.bt << bt
        hm.save!

        bt.hm.should == hm
        hm.bt.should == [bt]
      end

      it "should the relationship be expressed through the predicates of both entities, when given to the 'has_many' object" do
        pending "Cannot use the 'relationships' method on the 'has_many' relation"
        bt = BelongsTo.create
        hm = HasMany.create

        hm.bt << bt
        hm.save!

        bt.relationships(:is_part_of).should == [hm.internal_uri]
        hm.relationships(:is_part_of).should == [bt.internal_uri]
      end

      after(:each) do
        BelongsTo.all.each { |bt| bt.destroy }
        HasMany.all.each { |hm| hm.destroy }
      end
    end

    describe "with different relational property" do
      before :all do
        class BelongsTo < ActiveFedora::Base
          belongs_to :hm, :class_name => "HasMany", :property => :is_part_of
        end
        class HasMany < ActiveFedora::Base
          has_many :bt, :class_name => "BelongsTo", :property => :has_part
        end
      end

      it "should not start with any relationships" do
        bt = BelongsTo.new
        hm = HasMany.new
        bt.hm.should be_nil
        hm.bt.should == []
      end

      it "should be possible to save the relationship directly on the 'belongs_to' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        bt.hm = hm
        bt.save.should == true
        bt.hm.should == hm
      end

      it "should be possible to save the relationship using the pids on the 'belongs_to' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        bt.hm_id = hm.pid
        bt.save!

        bt.hm.should == hm
        bt.hm_id.should == hm.pid
      end

      it "should be possible to find the related object on the 'belongs_to' object through the relationship predicate using the internal uri" do
        bt = BelongsTo.create
        hm = HasMany.create

        bt.hm = hm
        bt.save!

        bt.relationships(:is_part_of).should == [hm.internal_uri]
      end

      it "should the relationship be defined only at the 'belongs_to' entity, when given to the 'belongs_to' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        bt.hm = hm
        bt.save!

        bt.hm.should == hm
        hm.bt.should == []
      end

      it "should the relationship be expressed through the predicates of both entities, when given to the 'belongs_to' object" do
        pending "Cannot use the 'relationships' method on the 'has_many' relation"
        bt = BelongsTo.create
        hm = HasMany.create

        bt.hm = hm
        bt.save!

        bt.relationships(:is_part_of).should == [hm.internal_uri]
        hm.relationships(:is_part_of).should == [bt.internal_uri]
      end

      it "should be possible to save the relationship on the 'has_many' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        hm.bt << bt
        hm.save.should == true
        hm.bt.should == [bt]
      end

      it "should be possible to save the relationship using the pids on the 'has_many' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        hm.bt_ids = [bt.pid]
        hm.save!

        hm.bt.should == [bt]
        hm.bt_ids.should == [bt.pid]
      end

      it "should be possible to find the related object on the 'has_many' object through the relationship predicate using the internal uri" do
        pending "Cannot use the 'relationships' method on the 'has_many' relation"
        bt = BelongsTo.create
        hm = HasMany.create

        hm.bt << bt
        hm.save!

        hm.relationships(:is_part_of).should == [bt.internal_uri]
      end

      it "should the relationship be defined only at the 'has_many' entity, when given to the 'has_many' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        hm.bt << bt
        hm.save!

        bt.hm.should be_nil
        hm.bt.should == [bt]
      end

      it "should the relationship be expressed through the predicates of both entities, when given to the 'has_many' object" do
        pending "Cannot use the 'relationships' method on the 'has_many' relation"
        bt = BelongsTo.create
        hm = HasMany.create

        hm.bt << bt
        hm.save!

        bt.relationships(:is_part_of).should == [hm.internal_uri]
        hm.relationships(:is_part_of).should == [bt.internal_uri]
      end

      after(:each) do
        BelongsTo.all.each { |bt| bt.destroy }
        HasMany.all.each { |hm| hm.destroy }
      end
    end

    describe "with different but inverse relational property" do
      before :all do
        class BelongsTo < ActiveFedora::Base
          belongs_to :hm, :class_name => "HasMany", :property => :is_part_of, :inverse_of => :has_part
        end
        class HasMany < ActiveFedora::Base
          has_many :bt, :class_name => "BelongsTo", :property => :has_part, :inverse_of => :is_part_of
        end
      end

      it "should not start with any relationships" do
        bt = BelongsTo.new
        hm = HasMany.new
        bt.hm.should be_nil
        hm.bt.should == []
      end

      it "should be possible to save the relationship directly on the 'belongs_to' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        bt.hm = hm
        bt.save.should == true
        bt.hm.should == hm
      end

      it "should be possible to save the relationship using the pids on the 'belongs_to' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        bt.hm_id = hm.pid
        bt.save!

        bt.hm.should == hm
        bt.hm_id.should == hm.pid
      end

      it "should be possible to find the related object on the 'belongs_to' object through the relationship predicate using the internal uri" do
        bt = BelongsTo.create
        hm = HasMany.create

        bt.hm = hm
        bt.save!

        bt.relationships(:is_part_of).should == [hm.internal_uri]
      end

      it "should the relationship be defined at both entities, when given to the 'belongs_to' object" do
        pending "Apparently there is an issue with the 'inverse_of' attribute"
        bt = BelongsTo.create
        hm = HasMany.create

        bt.hm = hm
        bt.save!

        bt.hm.should == hm
        hm.bt.should == [bt]
      end

      it "should the relationship be expressed through the predicates of both entities, when given to the 'belongs_to' object" do
        pending "Cannot use the 'relationships' method on the 'has_many' relation"
        bt = BelongsTo.create
        hm = HasMany.create

        bt.hm = hm
        bt.save!

        bt.relationships(:is_part_of).should == [hm.internal_uri]
        hm.relationships(:is_part_of).should == [bt.internal_uri]
      end

      it "should be possible to save the relationship on the 'has_many' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        hm.bt << bt
        hm.save.should == true
        hm.bt.should == [bt]
      end

      it "should be possible to save the relationship using the pids on the 'has_many' object" do
        bt = BelongsTo.create
        hm = HasMany.create

        hm.bt_ids = [bt.pid]
        hm.save!

        hm.bt.should == [bt]
        hm.bt_ids.should == [bt.pid]
      end

      it "should be possible to find the related object on the 'has_many' object through the relationship predicate using the internal uri" do
        pending "Cannot use the 'relationships' method on the 'has_many' relation"
        bt = BelongsTo.create
        hm = HasMany.create

        hm.bt << bt
        hm.save!

        hm.relationships(:is_part_of).should == [bt.internal_uri]
      end

      it "should the relationship be defined at both entities, when given to the 'has_many' object" do
        pending "Apparently there is an issue with the 'inverse_of' attribute"
        bt = BelongsTo.create
        hm = HasMany.create

        hm.bt << bt
        hm.save!

        bt.hm.should == hm
        hm.bt.should == [bt]
      end

      it "should the relationship be expressed through the predicates of both entities, when given to the 'has_many' object" do
        pending "Cannot use the 'relationships' method on the 'has_many' relation"
        bt = BelongsTo.create
        hm = HasMany.create

        hm.bt << bt
        hm.save!

        bt.relationships(:is_part_of).should == [hm.internal_uri]
        hm.relationships(:is_part_of).should == [bt.internal_uri]
      end

      after(:each) do
        BelongsTo.all.each { |bt| bt.destroy }
        HasMany.all.each { |hm| hm.destroy }
      end
    end
  end

  describe "between two has_and_belongs_to_many" do
    before :all do
      #pending "Test other stuff"
    end

    describe "with same relational property" do
      before :all do
        class Habtm1 < ActiveFedora::Base
          has_and_belongs_to_many :other, :class_name => "Habtm2", :property => :is_part_of
        end
        class Habtm2 < ActiveFedora::Base
          has_and_belongs_to_many :other, :class_name => "Habtm1", :property => :is_part_of
        end
      end

      it "should not start with any relationships" do
        hab1 = Habtm1.create
        hab2 = Habtm2.create
        hab1.other.should == []
        hab2.other.should == []
      end

      it "should be possible to save the relationship directly on only one object" do
        hab1 = Habtm1.create
        hab2 = Habtm2.create

        hab1.other = [hab2]
        hab1.save.should == true
        hab1.other.should == [hab2]
      end

      it "should be possible to save the relationship using the pids on only one object" do
        hab1 = Habtm1.create
        hab2 = Habtm2.create

        hab1.other_ids = [hab2.pid]
        hab1.save!

        hab1.other.should == [hab2]
        hab1.other_ids.should == [hab2.pid]
      end

      it "should be possible to find the related object on one object through the relationship predicate using the internal uri" do
        hab1 = Habtm1.create
        hab2 = Habtm2.create

        hab1.other = [hab2]
        hab1.save!

        hab1.relationships(:is_part_of).should == [hab2.internal_uri]
      end

      it "should the relationship be defined at both entities, when given only to one object" do
        pending "Apparently the relationship is not defined at both entities."
        hab1 = Habtm1.create
        hab2 = Habtm2.create

        hab1.other = [hab2]
        hab1.save!

        hab1.other.should == [hab2]
        hab2.other.should == [hab1]
      end

      it "should the relationship be expressed through the predicates of both entities, when given to only one object" do
        pending "Apparently the relationship is not defined at both entities."
        hab1 = Habtm1.create
        hab2 = Habtm2.create

        hab1.other = [hab2]
        hab1.save!

        hab1.relationships(:is_part_of).should == [hab2.internal_uri]
        hab2.relationships(:is_part_of).should == [hab1.internal_uri]
      end

      after(:each) do
        Habtm1.all.each { |hab| hab.destroy }
        Habtm2.all.each { |hab| hab.destroy }
      end
    end

    describe "with different relational property" do
      before :all do
        class Habtm1 < ActiveFedora::Base
          has_and_belongs_to_many :other, :class_name => "Habtm2", :property => :has_part
        end
        class Habtm2 < ActiveFedora::Base
          has_and_belongs_to_many :other, :class_name => "Habtm1", :property => :is_part_of
        end
      end

      it "should not start with any relationships" do
        hab1 = Habtm1.create
        hab2 = Habtm2.create
        hab1.other.should == []
        hab2.other.should == []
      end

      it "should be possible to save the relationship directly on only one object" do
        hab1 = Habtm1.create
        hab2 = Habtm2.create

        hab1.other = [hab2]
        hab1.save.should == true
        hab1.other.should == [hab2]
      end

      it "should be possible to save the relationship using the pids on only one object" do
        hab1 = Habtm1.create
        hab2 = Habtm2.create

        hab1.other_ids = [hab2.pid]
        hab1.save!

        hab1.other.should == [hab2]
        hab1.other_ids.should == [hab2.pid]
      end

      it "should be possible to find the related object on one object through the relationship predicate using the internal uri" do
        pending "Apparently the relationship is not defined at both entities."
        hab1 = Habtm1.create
        hab2 = Habtm2.create

        hab1.other = [hab2]
        hab1.save!

        hab1.relationships(:is_part_of).should == [hab2.internal_uri]
      end

      it "should the relationship be defined at both entities, when given only to one object" do
        pending "Apparently the relationship is not defined at both entities."
        hab1 = Habtm1.create
        hab2 = Habtm2.create

        hab1.other = [hab2]
        hab1.save!

        hab1.other.should == [hab2]
        hab2.other.should == [hab1]
      end

      it "should the relationship be expressed through the predicates of both entities, when given to only one object" do
        pending "Apparently the relationship is not defined at both entities."
        hab1 = Habtm1.create
        hab2 = Habtm2.create

        hab1.other = [hab2]
        hab1.save!

        hab1.relationships(:is_part_of).should == [hab2.internal_uri]
        hab2.relationships(:is_part_of).should == [hab1.internal_uri]
      end

      after(:each) do
        Habtm1.all.each { |hab| hab.destroy }
        Habtm2.all.each { |hab| hab.destroy }
      end
    end

    describe "with different but inverse relational property" do
      before :all do
        class Habtm1 < ActiveFedora::Base
          has_and_belongs_to_many :other, :class_name => "Habtm2", :property => :has_part, :inverse_of => :is_part_of
        end
        class Habtm2 < ActiveFedora::Base
          has_and_belongs_to_many :other, :class_name => "Habtm1", :property => :is_part_of, :inverse_of => :has_part
        end
      end

      it "should not start with any relationships" do
        hab1 = Habtm1.create
        hab2 = Habtm2.create
        hab1.other.should == []
        hab2.other.should == []
      end

      it "should be possible to save the relationship directly on only one object" do
        hab1 = Habtm1.create
        hab2 = Habtm2.create

        hab1.other = [hab2]
        hab1.save.should == true
        hab1.other.should == [hab2]
      end

      it "should be possible to save the relationship using the pids on only one object" do
        hab1 = Habtm1.create
        hab2 = Habtm2.create

        hab1.other_ids = [hab2.pid]
        hab1.save!

        hab1.other.should == [hab2]
        hab1.other_ids.should == [hab2.pid]
      end

      it "should be possible to find the related object on one object through the relationship predicate using the internal uri" do
        pending "Apparently the relationship is not defined at both entities."
        hab1 = Habtm1.create
        hab2 = Habtm2.create

        hab1.other = [hab2]
        hab1.save!

        hab1.relationships(:is_part_of).should == [hab2.internal_uri]
      end

      it "should the relationship be defined at both entities, when given only to one object" do
        hab1 = Habtm1.create
        hab2 = Habtm2.create

        hab1.other = [hab2]
        hab1.save!

        hab1.other.should == [hab2]
        hab2.other.should == [hab1]
      end

      it "should the relationship be expressed through the predicates of both entities, when given to only one object" do
        pending "Apparently the relationship is not defined at both entities."
        hab1 = Habtm1.create
        hab2 = Habtm2.create

        hab1.other = [hab2]
        hab1.save!

        hab1.relationships(:is_part_of).should == [hab2.internal_uri]
        hab2.relationships(:is_part_of).should == [hab1.internal_uri]
      end

      after(:each) do
        Habtm1.all.each { |hab| hab.destroy }
        Habtm2.all.each { |hab| hab.destroy }
      end
    end
  end
end