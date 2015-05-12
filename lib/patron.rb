class Patron
  attr_reader(:name, :id, :book_history)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    returned_patrons = DB.exec("SELECT * FROM patrons;")
    patrons = []
    returned_patrons.each() do |patron|
      name = patron.fetch("name")
      id = patron.fetch("id").to_i()
      patrons.push(Patron.new({:name => name, :id => id}))
    end
    patrons
  end

  define_singleton_method(:find) do |id|
    @id = id
    result = DB.exec("SELECT * FROM patrons WHERE id = #{@id}")
    @name = result.first().fetch("name")
    Patron.new({:name => @name, :id => @id})
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO patrons (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  define_method(:==) do |another_patron|
    self.name().==(another_patron.name()).&(self.id().==(another_patron.id()))
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name, @name)
    @id = self.id()
    DB.exec("UPDATE patrons SET name = '#{@name}' WHERE id = #{@id};")

    attributes.fetch(:copies_id, []).each() do |copies_id|
      DB.exec("INSERT INTO checkouts (copies_id, patron_id) VALUES (#{copies_id}, #{self.id()});")
    end
  end

  define_method(:delete) do
    DB.exec("DELETE FROM checkouts WHERE patron_id = #{self.id()};")
    DB.exec("DELETE FROM patrons WHERE id = #{self.id()};")
  end

  define_method(:copies) do
    patron_copies = []
    results = DB.exec("SELECT copies_id FROM checkouts WHERE patron_id = #{self.id()};")
    results.each() do |result|
      copies_id = result.fetch("copies_id").to_i()
      copy = DB.exec("SELECT * FROM copies WHERE id = #{copies_id};")
      title = copy.first().fetch("title")
      patron_copies.push(Copy.new({:title => title, :id => copies_id}))
    end
    patron_copies
  end

  # define_method(:return) do |book|
  #   DB.exec("DELETE FROM checkouts WHERE copies_id = #{book.id()};")
  # end

end
