# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PersonTeiRepresentation do
  describe "#create" do
    it "should be created without arguments" do
      person_tei_representation = PersonTeiRepresentation.new
      person_tei_representation.save.should == true
    end

    it "should be created with arguments" do
      person_tei_representation = PersonTeiRepresentation.new(:forename=>"the forename", :surname=>"the lastname")
      person_tei_representation.save.should == true
    end
  end

  describe "#update" do
    before do
      @person_tei_representation = PersonTeiRepresentation.new
      @person_tei_representation.save!
    end

    it "should be possible to update the name" do
      @person_tei_representation.forename = "a forename"
      @person_tei_representation.save.should == true
      person_tei_representation1 = PersonTeiRepresentation.find(@person_tei_representation.pid)
      person_tei_representation1.forename.should == "a forename"
    end
  end

  describe "#variables" do
    before do
      @person_tei_representation = PersonTeiRepresentation.new
      @person_tei_representation.save!
    end

    it "should be possible to locate from the pid" do
      person_tei_representation2 = PersonTeiRepresentation.find(@person_tei_representation.pid)
      person_tei_representation2.should_not be_nil
      person_tei_representation2.should == @person_tei_representation
    end

    it "should have a string forename" do
      @person_tei_representation.forename.should be_kind_of String
    end

    it "should have a string last" do
      @person_tei_representation.surname.should be_kind_of String
    end

    it "should have other variables validated" do
      pending "TODO"
    end
  end


  describe "#delete" do
    before do
      @person_tei_representation = PersonTeiRepresentation.new
      @person_tei_representation.save!
    end

    it "should be possible to delete" do
      count = PersonTeiRepresentation.count
      @person_tei_representation.destroy
      PersonTeiRepresentation.count.should == count-1
    end
  end

  describe "#from module" do
    before do
      @person_tei_representation = PersonTeiRepresentation.new
      @person_tei_representation.save!
    end

    it "should have the required datastreams" do
      @person_tei_representation.datastreams.keys.should include("descMetadata")
      @person_tei_representation.descMetadata.should be_kind_of Datastreams::AdlTeiP5
    end

    it "should have the attributes of an author and support update_attributes" do
      attributes_hash = {
          surname: "Arrebo",
          forename: "Anders",
          date_of_birth: "1587",
          date_of_death: "1637",
          sample_quotation:"See ud der springer frem den grumme Diur-forskrecker,
          En Jæger uden Hund blod-gridsk i marken trecker,
          Nu er hans Klædning hviid, nu guul, nu trøjen sverted,
          Langøret, øje-glubsk, skarp-kløred, vel-bestierted,
          Jeg meen den Løve kæk, stormodig ofver alle,
          Den fleeste Markens Diur maae knælende food-falde.
          Hans Fødsel selsom er, naar hand til Verden længer,
          Sit eget Moders Liif, u-mildelig hand sprenger:
          Af Redsel slet forbaust, half død tre dage slummer,
          Ved Fadrens skrek'lig brøl til Liif oc Krafter kommer.",
          sample_quotation_source: "Hexaëmeron i Samlede Skrifter bd. 1, s. 226)",
          short_biography: "1587 	Født i Ærøskøbing
          1608 	Præst i København
          1610 	Magister
          1618 	Biskop over Trondhjems stift
          1622 	Fradømt sit embede
          1623 	K. Davids Psalter, revideret 1627
          1626 	Sognepræst i Vordingborg
          1631-37 	Hovedværket Hexaëmeron, udgivet posthumt 1661
          1637 	Død i Vordingborg",
          period: "Renæssance"
      }

      @person_tei_representation.update_attributes(attributes_hash)

      @person_tei_representation.surname.should == attributes_hash[:surname]
      @person_tei_representation.forename.should == attributes_hash[:forename]
      @person_tei_representation.date_of_birth.should == attributes_hash[:date_of_birth]
      @person_tei_representation.date_of_death.should == attributes_hash[:date_of_death]
      @person_tei_representation.sample_quotation.first.should == attributes_hash[:sample_quotation]
      @person_tei_representation.sample_quotation_source.first.should == attributes_hash[:sample_quotation_source]
      @person_tei_representation.short_biography.first.should == attributes_hash[:short_biography]
      @person_tei_representation.period.should == attributes_hash[:period]
    end

    it "should have an author image file datastream" do
      author_image = File.open(File.join(File.dirname(__FILE__), '..', 'fixtures', "aoa._foto.jpg"))
      @person_tei_representation.add_file_datastream(author_image, :mimeType => 'image/jpg', :dsLabel => 'authorImageFile')
      @person_tei_representation.save
    end
  end
  
  after do
    PersonTeiRepresentation.all.each { |ptr| ptr.delete }
  end
end
