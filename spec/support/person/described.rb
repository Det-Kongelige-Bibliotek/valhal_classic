# -*- encoding : utf-8 -*-
shared_examples "a person with descriptions" do
  # subject must pass all validation for that manifestation
  # if not these tests will fail
  # look at person_spec.rb for how to override subject to provide a valid object
  let(:person) { subject }
  let(:default_work) { Work.create(title: "Super Work") }
  let(:default_book) { Book.create(title: "Super Book") }

  describe "#describing_manifestations" do
    it "add a book" do
      person.save!
      book = default_book
      person.describing_manifestations << book
      person.save
      person.reload

      person.describing_manifestations.should include book
    end

    it "add a work" do
      person.save!
      work = default_work
      person.describing_manifestations << work
      person.save
      person.reload

      person.describing_manifestations.should include work
    end

    it "add a work and a book" do
      person.save!
      book = default_book
      work = default_work
      person.describing_manifestations << book << work
      person.save
      person.reload

      person.describing_manifestations.should include work, book
    end

    it "remove a book" do
      person.save!
      book = default_book
      person.describing_manifestations << book
      person.save
      person.reload

      person.describing_manifestations.delete(book)
      person.save
      person.reload

      person.describing_manifestations.should be_empty
    end

    it "remove a work" do
      person.save!
      work = default_work
      person.describing_manifestations << work << default_work << default_work
      person.save
      person.reload

      person.describing_manifestations.delete(work)
      person.save
      person.reload

      person.describing_manifestations.should_not include work
    end

    it "remove all manifestations" do
      person.save!
      person.describing_manifestations << default_work << default_book << default_work
      person.save
      person.reload

      person.describing_manifestation_ids = []
      person.save
      person.reload

      person.describing_manifestations.should be_empty
    end
  end

  describe "describing_books" do
    context "no books, only works" do
      it "return empty Array" do
        person.save!
        person.describing_manifestations << default_work << default_work
        person.save
        person.reload

        person.describing_books.should be_empty
      end
    end

    context "one book, no works" do
      it "return one book in a Array" do
        person.save!
        book = default_book
        person.describing_manifestations << book
        person.save
        person.reload

        person.describing_books.should == [book]
      end
    end

    context "many books and many works" do
      it "return a array of books" do
        person.save!
        person.describing_manifestations << default_book << default_book << default_book << default_work << default_work << default_work
        person.save
        person.reload

        person.describing_books.each { |b| b.should be_kind_of Book }
      end
    end
  end

  describe "#describing_works" do
    context "no works, only books" do
      it "return empty Array" do
        person.save!
        person.describing_manifestations << default_book << default_book
        person.save
        person.reload

        person.describing_works.should be_empty
      end
    end

    context "one work, no books" do
      it "return one work in a Array" do
        person.save!
        work = default_work
        person.describing_manifestations << work
        person.save
        person.reload

        person.describing_works.should == [work]
      end
    end

    context "many works and many books" do
      it "return a array of works" do
        person.save!
        person.describing_manifestations << default_book << default_book << default_book << default_work << default_work << default_work
        person.save
        person.reload

        person.describing_works.each { |b| b.should be_kind_of Work }
      end
    end
  end

  describe "#is_described_by_book?" do
    context "no books, only works" do
      it "return false" do
        person.save!
        person.describing_manifestations << default_work << default_work
        person.save
        person.reload

        person.is_described_by_book?.should be_false
      end
    end

    context "many books and many works" do
      it "return true" do
        person.save!
        person.describing_manifestations << default_work << default_work << default_book << default_book
        person.save
        person.reload

        person.is_described_by_book?.should be_true
      end
    end

    context "book and no works" do
      it "return true" do
        person.save!
        person.describing_manifestations << default_book
        person.save
        person.reload

        person.is_described_by_book?.should be_true
      end
    end
  end

  describe "#is_described_by_work?" do
    context "no work, only books" do
      it "return false" do
        person.save!
        person.describing_manifestations << default_book << default_book
        person.save
        person.reload

        person.is_described_by_work?.should be_false
      end
    end

    context "many works and many books" do
      it "return true" do
        person.save!
        person.describing_manifestations << default_work << default_work << default_book << default_book
        person.save
        person.reload

        person.is_described_by_work?.should be_true
      end
    end

    context "work and no books" do
      it "return true" do
        person.save!
        person.describing_manifestations << default_work
        person.save
        person.reload

        person.is_described_by_work?.should be_true
      end
    end
  end
end