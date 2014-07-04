# -*- encoding : utf-8 -*-
shared_examples "a person with concerns" do
  # subject must pass all validation for that manifestation
  # if not these tests will fail
  # look at person_spec.rb for how to override subject to provide a valid object
  let(:person) { subject }
  let(:default_work) { Work.create(title: "Super Work") }

  describe "#concerning_manifestations" do
    it "add a work" do
      person.save!
      work = default_work
      person.concerning_manifestations << work
      person.save
      person.reload

      person.concerning_manifestations.should include work
    end

    it "remove a work" do
      person.save!
      work = default_work
      person.concerning_manifestations << work << default_work << default_work
      person.save
      person.reload

      person.concerning_manifestations.delete(work)
      person.save
      person.reload

      person.concerning_manifestations.should_not include work
    end

    it "remove all manifestations" do
      person.save!
      person.concerning_manifestations << default_work << default_book << default_work
      person.save
      person.reload

      person.concerning_manifestation_ids = []
      person.save
      person.reload

      person.concerning_manifestations.should be_empty
    end
  end

  end

  describe "#is_concerned_by_work?" do
    context "many works and many books" do
      it "return true" do
        person.save!
        person.concerning_manifestations << default_work << default_work
        person.save
        person.reload

        person.is_concerned_by_work?.should be_true
      end
    end

    context "work and no books" do
      it "return true" do
        person.save!
        person.concerning_manifestations << default_work
        person.save
        person.reload

        person.is_concerned_by_work?.should be_true
      end
    end
  end