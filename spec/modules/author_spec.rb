# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Author do

  before(:each) do
    @author = Author.create
  end

  it "should have the required datastreams" do

    @author.datastreams.keys.should include("descMetadata")
    @author.descMetadata.should be_kind_of Datastreams::AdlTeiP5
  end

  it "should have the attributes of an author and support update_attributes" do
    attributes_hash = {
        surname: "Arrebo",
        forename: "Anders",
        date_of_birth: "1587",
        date_of_death: "1637",
        sample_quotation: "See ud der springer frem den grumme Diur-forskrecker,
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
        #"portrait_image" => "/images/ff_foto/aoa._foto.jpg",
        short_biography: "1587 	Født i Ærøskøbing
                            1608 	Præst i København
                            1610 	Magister
                            1618 	Biskop over Trondhjems stift
                            1622 	Fradømt sit embede
                            1623 	K. Davids Psalter, revideret 1627
                            1626 	Sognepræst i Vordingborg
                            1631-37 	Hovedværket Hexaëmeron, udgivet posthumt 1661
                            1637 	Død i Vordingborg"
    }

    @author.update_attributes(attributes_hash)

    @author.surname.should == attributes_hash[:surname]
    @author.forename.should == attributes_hash[:forename]
    @author.date_of_birth.should == attributes_hash[:date_of_birth]
    @author.date_of_death.should == attributes_hash[:date_of_death]
    @author.sample_quotation.first.should == attributes_hash[:sample_quotation]
    @author.sample_quotation_source.first.should == attributes_hash[:sample_quotation_source]
    #@author.portrait_image.should == attributes_hash["portrait_image"]
    @author.short_biography.first.should == attributes_hash[:short_biography]
  end

  after(:each) do
    @author.delete
  end
end
