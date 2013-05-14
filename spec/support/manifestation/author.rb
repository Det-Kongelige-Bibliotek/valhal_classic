# -*- encoding : utf-8 -*-

shared_examples "a manifestation with authors" do
  # subject must pass all validation for that manifestation
  # if not all these tests will fail
  # look at book_spec.rb for how to override subject to provide a valid object
  let(:manifestation) { subject }
  let(:default_person) { Person.create(firstname: "first_test #{Time.now.usec}", lastname: "last_test") }

  describe "#authors" do

    it "add a person to authors" do
      person = default_person
      manifestation.save! #a manifestation must be saved before adding a person!
      manifestation.authors << person
      manifestation.save!

      manifestation.authors.should include person
    end

    it "retrieve a manifestation via author(person)" do
      person = default_person
      manifestation.save!
      manifestation.authors << person
      manifestation.save!

      person.authored_manifestations.should include manifestation
    end

    it "remove a author on a manifestation" do
      authors = []
      authors << default_person
      authors << default_person
      authors << default_person
      manifestation.save!
      authors.each do |author|
        manifestation.authors << author
      end
      manifestation.save!
      manifestation.authors.delete(authors[1])
      manifestation.save!

      manifestation.reload

      manifestation.authors.should_not include authors[1]
    end

    it "remove all authors from a manifestation" do
      manifestation.save!
      manifestation.authors << default_person
      manifestation.authors << default_person
      manifestation.authors << default_person
      manifestation.save
      manifestation.reload

      manifestation.author_ids = []
      manifestation.save
      manifestation.reload

      manifestation.authors.should be_empty
    end
  end

  describe "#clear_authors" do

    context "no authors" do
      it "return false" do
        manifestation.save!

        manifestation.clear_authors.should be_false
      end
    end

    context "one author" do
      it "remove the author and return true" do
        manifestation.save!
        manifestation.authors << default_person
        manifestation.save
        manifestation.reload

        manifestation.clear_authors.should be_true
        manifestation.save
        manifestation.reload

        manifestation.authors.should be_empty
      end
    end

    context "many authors" do
      it "remove the authors and return true" do
        manifestation.save!
        manifestation.authors << default_person
        manifestation.authors << default_person
        manifestation.authors << default_person
        manifestation.save
        manifestation.reload

        manifestation.clear_authors.should be_true
        manifestation.save
        manifestation.reload

        manifestation.authors.should be_empty
      end
    end
  end

  describe "#has_author?" do

    context "no author" do
      it "return false" do
        manifestation.save!
        manifestation.has_author?.should be_false
      end
    end

    context "one author" do
      it "return true" do
        author = default_person
        manifestation.save!
        manifestation.authors << author
        manifestation.save!
        manifestation.has_author?.should be_true
      end
    end

    context "many authors" do
      it "return true" do
        authors = []
        authors << default_person
        authors << default_person
        authors << default_person
        manifestation.save!
        authors.each do |author|
          manifestation.authors << author
        end

        manifestation.save!
        manifestation.reload
        manifestation.has_author?.should be_true
      end
    end
  end
end

