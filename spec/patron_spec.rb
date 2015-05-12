require 'spec_helper'

describe(Patron) do

  describe('#name') do
    it("returns the patron's name") do
      patron = Patron.new({:name => "Robert", :id => nil})
      expect(patron.name()).to(eq("Robert"))
    end
  end

  describe("#id") do
    it("returns the patron's id") do
      patron = Patron.new({:name => "Robert", :id => 1})
      expect(patron.id()).to(eq(1))
    end
  end

  describe(".all") do
    it("starts off with no patrons") do
      expect(Patron.all()).to(eq([]))
    end
  end

  describe(".find") do
    it("returns a patron by its ID number") do
      test_patron = Patron.new({:name => "Robert", :id => nil})
      test_patron.save()
      test_patron2 = Patron.new({:name => "Sam", :id => nil})
      test_patron2.save()
      expect(Patron.find(test_patron2.id())).to(eq(test_patron2))
    end
  end

  describe("#==") do
    it("is the same patron if it has the same name and id") do
      patron = Patron.new({:name => "Robert", :id => nil})
      patron2 = Patron.new(:name => "Robert", :id => nil)
      expect(patron).to(eq(patron2))
    end
  end

  describe("#update") do
    it("lets you update patrons in the database") do
      patron = Patron.new({:name => "Robert", :id => nil})
      patron.save()
      patron.update({:name => "Sam"})
      expect(patron.name()).to(eq("Sam"))
    end
  end

  describe("#delete") do
    it("lets you delete a patron form the databse") do
      patron = Patron.new({:name => "Robert", :id => nil})
      patron.save()
      patron2 = Patron.new({:name => "Sam", :id => nil})
      patron2.save()
      patron.delete()
      expect(Patron.all()).to(eq([patron2]))
    end
  end

  describe('#copies') do
    it("returns all of the copies the patron has checked out") do
      patron = Patron.new(:name => "Bob", :id => nil)
      patron.save()
      book1 = Copy.new({:title => "Book One", :id => nil})
      book1.save()
      book2 = Copy.new({:title => "Book Two", :id => nil})
      book2.save()
      patron.update({:copies_id => [book1.id(), book2.id()]})
      expect(patron.copies()).to(eq([book1, book2]))
    end
  end
end
