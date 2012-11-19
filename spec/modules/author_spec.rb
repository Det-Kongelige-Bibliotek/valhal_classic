# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Author do

  before(:each) do
    @author = Author.new
  end

  it "should have the required datastreams" do

    @author.datastreams.keys.should include("descMetadata")
    @author.descMetadata.should be_kind_of Datastreams::AdlTeiP5Datastream
  end

  it "should have the attributes of an author and support update_attributes" do
    attributes_hash = {
      "author_name" => "Anders C Arrebo",
      "year_of_birth" => "1587",
      "year_of_death" => "1637",
      "example_quotation" => "See ud der springer frem den grumme Diur-forskrecker,
        En Jæger uden Hund blod-gridsk i marken trecker,
        Nu er hans Klædning hviid, nu guul, nu trøjen sverted,
        Langøret, øje-glubsk, skarp-kløred, vel-bestierted,
        Jeg meen den Løve kæk, stormodig ofver alle,
        Den fleeste Markens Diur maae knælende food-falde.
        Hans Fødsel selsom er, naar hand til Verden længer,
        Sit eget Moders Liif, u-mildelig hand sprenger:
        Af Redsel slet forbaust, half død tre dage slummer,
        Ved Fadrens skrek'lig brøl til Liif oc Krafter kommer.
        Hexaëmeron i Samlede Skrifter bd. 1, s. 226)",
      "portrait_image" => "/images/ff_foto/aoa._foto.jpg",
      "short_biography" => "1587 	Født i Ærøskøbing
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

    @author.author_name.should == attributes_hash["author_name"]
    @author.year_of_birth.should == attributes_hash["year_of_birth"]
    @author.year_of_death.should == attributes_hash["year_of_death"]
    @author.example_quotation.should == attributes_hash["example_quotation"]
    @author.portrait_image.should == attributes_hash["portrait_image"]
    @author.short_biography.should == attributes_hash["short_biography"]
  end
end
