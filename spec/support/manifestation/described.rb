# -*- encoding : utf-8 -*-

shared_examples "a manifestation with descriptions" do
  # subject must pass all validation for that manifestation
  # if not these tests will fail
  # look at book_spec.rb for how to override subject to provide a valid object
  let(:manifestation) { subject }
  let(:default_person) { Person.create(firstname: "first_test #{Time.now.usec}", lastname: "last_test") }

  describe "#people_described" do
    it "add person to people_described" do
      person = default_person
      manifestation.save!
      manifestation.people_described << person
      manifestation.save!
      manifestation.reload

      manifestation.people_described.should include person
    end

    it "remove a person from people_described" do
      person = default_person
      manifestation.save!
      manifestation.people_described << person
      manifestation.save!
      manifestation.people_described.delete(person)
      manifestation.save
      manifestation.reload

      manifestation.people_described.should be_empty
    end

    it "remove all people from people_described" do
      manifestation.save!
      manifestation.people_described << default_person
      manifestation.people_described << default_person
      manifestation.people_described << default_person
      manifestation.save!
      manifestation.reload

      manifestation.clear_described_people
      manifestation.save
      manifestation.reload

      manifestation.people_described.should be_empty
    end
  end

  describe "#has_described_person?" do
    context "no described people"do
      it "return false" do
        manifestation.save!
        manifestation.has_described_person?.should be_false
      end
    end

    context "one described person" do
      it "return true" do
        manifestation.save!
        manifestation.people_described << default_person
        manifestation.save!
        manifestation.reload

        manifestation.has_described_person?.should be_true
      end
    end

    context "many described people" do
      it "return true" do
        manifestation.save!
        manifestation.people_described << default_person
        manifestation.people_described << default_person
        manifestation.people_described << default_person
        manifestation.save!
        manifestation.reload

        manifestation.has_described_person?.should be_true
      end
    end

  end
end