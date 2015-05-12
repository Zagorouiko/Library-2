class Copy

  attr_reader(:title, :book_author, :id)

  define_method(:initialize) do |attributes|
    @title = attributes.fetch(:title)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    returned_copies = DB.exec("SELECT * FROM copies;")
    copies = []
    returned_copies.each() do |copy|
      title = copy.fetch("title")
      book_author = copy.fetch("book_author")
      id = copy.fetch("id").to_i()
      copies.push(Copy.new({:title => title, :book_author => book_author, :id => id}))
    end
    copies
  end

  define_singleton_method(:find) do |id|
    @id = id
    result = DB.exec("SELECT * FROM copies WHERE id = #{@id};")
    @title = result.first().fetch("title")
    @book_author = result.first().fetch("book_author")
    Copy.new({:title => @title, :book_author => @book_author, :id => @id})
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO copies (title, book_author) VALUES ('#{@title}', '#{@book_author}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  define_method(:==) do |another_book|
    self.title().==(another_book.title()).&(self.book_author().==(another_book.book_author())).&(self.id().==(another_book.id()))
  end

  define_method(:update) do |attributes|
    @title = attributes.fetch(:title, @title)
    @book_author = attributes.fetch(:book_author, @book_author)
    @id = self.id()
    DB.exec("UPDATE copies SET title = '#{@title}', book_author = '#{@book_author}' WHERE id = #{@id};")
  end

  define_method(:delete) do
    DB.exec("DELETE FROM checkouts WHERE copies_id = #{self.id()};")
    DB.exec("DELETE FROM copies WHERE id = #{self.id()};")
  end
end
