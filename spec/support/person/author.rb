# -*- encoding : utf-8 -*-

shared_examples "a person with manifestations" do
  # subject must pass all validation for that manifestation
  # if not these tests will fail
  # look at person_spec.rb for how to override subject to provide a valid object
  let(:person) { subject }
  let(:default_work) { Work.create(title: "Super Work") }

  describe "#authored_manifestations" do
    it "add a work" do
      person.save!
      work = default_work
      person.authored_manifestations << work
      person.save
      person.reload

      person.authored_manifestations.should include work
    end
  end

    it "remove a work" do
      person.save!
      work = default_work
      person.authored_manifestations << work << default_work << default_work
      person.save
      person.reload

      person.authored_manifestations.delete(work)
      person.save
      person.reload

      person.authored_manifestations.should_not include work
    end

    it "remove all manifestations" do
      person.save!
      person.authored_manifestations << default_work
      person.save
      person.reload

      person.authored_manifestation_ids = []
      person.save
      person.reload

      person.authored_manifestations.should be_empty
    end
  end

  describe "#is_author_of_work?" do
    context "work" do
      it "return true" do
        person.save!
        person.authored_manifestations << default_work
        person.save
        person.reload

        person.is_author_of_work?.should be_true
      end
    end
  end