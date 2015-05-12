require('spec_helper')


describe(Copy) do

  describe("#title") do
    it("returns the title") do
    copy = Copy.new({:title => "Survivor", :book_author => "Chuck Palahniuk", :id => nil})
    expect(copy.title()).to(eq("Survivor"))
  end
 end

 describe('#id') do
   it('returns the id') do
     copy = Copy.new({:title => "Survivor", :book_author => "Chuck Palahniuk", :id => 1})
     expect(copy.id()).to(eq(1))
   end
end

  describe('.all') do
    it("starts off with no books") do
    expect(Copy.all()).to(eq([]))
  end
end


  describe(".find") do
    it('returns a book by its ID number') do
      test_book = Copy.new({:title => "Survivor", :book_author => "Chuck Palahniuk", :id => nil})
      test_book.save()
      test_book2 = Copy.new({:title => "Survivor", :book_author => "Chuck Palahniuk", :id => nil})
      test_book2.save()
      expect(Copy.find(test_book2.id())).to(eq(test_book2))
    end
  end

  describe("#==") do
    it("is the same book if it has the same name and id") do
      book = Copy.new({:title => "Survivor", :book_author => "Chuck Palahniuk", :id => nil})
      book2 = Copy.new({:title =>"Survivor", :book_author => "Chuck Palahniuk", :id => nil})
      expect(book).to(eq(book2))
    end
  end

  describe("#update") do
    it("lets you update books in the database") do
      book = Copy.new({:title => "Survivor", :book_author => "Chuck Palahniuk", :id => nil})
      book.save()
      book2 = Copy.new({:title => "Survivorr", :book_author => "Chuck Palahniukk", :id => nil})
      book2.save()
      book.update({:title => "Survivorr", :book_author => "Chuck Palahniukk", :id => nil})
    end
  end

  describe('#delete') do
    it("lets you delete a book from the database") do
      book = Copy.new({:title => "Survivor", :book_author => "Chuck Palahniuk", :id => nil})
      book.save()
      book2 = Copy.new({:title => "Survivorr", :book_author => "Chuck Palahniukk", :id => nil})
      book2.save()
      book.delete()
      expect(Copy.all()).to(eq([book2]))
    end
  end
end
