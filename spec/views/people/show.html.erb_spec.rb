# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "people/show" do
  describe 'default test' do
    before(:each) do
      @person = assign(:person, stub_model(Person))
    end

    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
    end
  end

  describe 'with a portrait' do
    before(:each) do
      @person = Person.create(:firstname => 'firstname', :lastname => 'lastname', :date_of_birth => Time.now.nsec.to_s)
      @portrait = Work.create(:work_type => 'PersonPortrait', :title => 'portrait of person')
      uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'test.png', type: 'image/png', tempfile: File.new("#{Rails.root}/spec/fixtures/rails.png"))
      @file = BasicFile.create!
      @file.add_file(uploaded_file, '1')
      rep = SingleFileRepresentation.create!
      rep.files << @file
      @portrait.representations << rep
      @portrait.people_concerned << @person
      @portrait.save!
    end

    it 'should have both portrait and relationship link to the image' do
      visit person_path(@person)

      page.has_link?(@portrait.get_title_for_display, :href => work_path(@portrait) + '?locale=en').should be_true
      page.should have_xpath("//img[@src=\"#{show_image_person_path @person}?locale=en\"]")
    end
  end

  describe 'with a non-portrait concerned work' do
    before(:each) do
      @person = Person.create(:firstname => 'firstname', :lastname => 'lastname', :date_of_birth => Time.now.nsec.to_s)
      @portrait = Work.create(:work_type => 'PersonDescription', :title => 'description of person')
      uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'test.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml"))
      @file = BasicFile.create!
      @file.add_file(uploaded_file, '1')
      rep = SingleFileRepresentation.create!
      rep.files << @file
      @portrait.representations << rep
      @portrait.people_concerned << @person
      @portrait.save!
    end

    it 'should have both portrait and relationship link to the image' do
      visit person_path(@person)

      page.has_link?(@portrait.get_title_for_display, :href => work_path(@portrait) + '?locale=en').should be_true
      page.should_not have_xpath("//img[@src=\"#{show_image_person_path @person}?locale=en\"]")
    end
  end

end
