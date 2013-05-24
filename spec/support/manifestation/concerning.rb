# -*- encoding : utf-8 -*-

shared_examples "a manifestation with concerns" do
  # subject must pass all validation for that manifestation
  # if not these tests will fail
  # look at book_spec.rb for how to override subject to provide a valid object
  let(:manifestation) { subject }
  let(:default_person) { Person.create(firstname: "first_test #{Time.now.nsec.to_s}", lastname: "last_test") }

  describe "#people_concerned" do
    it "add person to people_concerned" do
      person = default_person
      manifestation.save!
      manifestation.people_concerned << person
      manifestation.save!
      manifestation.reload

      manifestation.people_concerned.should include person
    end

    it "remove a person from people_concerned" do
      person = default_person
      manifestation.save!
      manifestation.people_concerned << person
      manifestation.save!
      manifestation.people_concerned.delete(person)
      manifestation.save
      manifestation.reload

      manifestation.people_concerned.should be_empty
    end

    it "remove all people from people_concerned" do
      manifestation.save!
      manifestation.people_concerned << default_person
      manifestation.save!
      manifestation.reload

      manifestation.has_concerned_person?.should be_true

      manifestation.clear_concerned_people
      manifestation.save
      manifestation.reload

      manifestation.people_concerned.should be_empty
    end
  end

  describe "#clear_concerned_people" do

    context "no concerned people" do
      it "return false" do
        manifestation.save!

        manifestation.clear_concerned_people.should be_false
      end
    end

    context "one concerned person" do
      it "remove the concerned person and return true" do
        manifestation.save!
        manifestation.people_concerned << default_person
        manifestation.save
        manifestation.reload

        manifestation.clear_concerned_people.should be_true
        manifestation.save
        manifestation.reload

        manifestation.people_concerned.should be_empty
      end
    end

    context "many people concerned" do
      it "remove the people concerned and return true" do
        manifestation.save!
        manifestation.people_concerned << default_person
        manifestation.people_concerned << default_person
        manifestation.people_concerned << default_person
        manifestation.save
        manifestation.reload

        manifestation.clear_concerned_people.should be_true
        manifestation.save
        manifestation.reload

        manifestation.people_concerned.should be_empty
      end
    end
  end

  describe "#has_concerned_person?" do
    context "no concerned people"do
      it "return false" do
        manifestation.save!
        manifestation.has_concerned_person?.should be_false
      end
    end

    context "one concerned person" do
      it "return true" do
        manifestation.save!
        manifestation.people_concerned << default_person
        manifestation.save!
        manifestation.reload

        manifestation.has_concerned_person?.should be_true
      end
    end

    context "many concerned people" do
      it "return true" do
        manifestation.save!
        manifestation.people_concerned << default_person
        manifestation.people_concerned << default_person
        manifestation.people_concerned << default_person
        manifestation.save!
        manifestation.reload

        manifestation.has_concerned_person?.should be_true
      end
    end

  end
end