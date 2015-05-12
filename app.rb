require 'sinatra'
require 'sinatra/reloader'
also_reload 'lib/**/*.rb'
require './lib/copy'
require './lib/patron'
require 'pg'
require 'pry'

DB = PG.connect({:dbname => "library"})

get('/') do
  erb(:index)
end

get('/librarian') do
  @copies = Copy.all()
  @patrons = Patron.all
  erb(:librarian)
end

get('/patron') do
  @patrons = Patron.all()
  erb(:patron)
end

post('/copies') do
  title = params.fetch("title")
  copy = Copy.new({:title => title, :id => nil})
  copy.save()
  @copies = Copy.all()
  erb(:success)
end

get('/copies/new') do
  erb(:copy_form)
end

get('/copies/:id') do
  @copy = Copy.find(params.fetch("id").to_i())
  erb(:copy_info)
end

post('/patrons') do
  name = params.fetch("name")
  patron = Patron.new({:name => name, :id => nil})
  patron.save()
  @patrons = Patron.all()
  erb(:success)
end

get('/patrons/new') do
  erb(:patron_form)
end

get('/patrons/:id') do
  @patron = Patron.find(params.fetch("id").to_i())
  @copies = Copy.all()
  erb(:patron_info)
end

patch('/patrons/:id') do
  patron_id = params.fetch('id').to_i()
  @patron = Patron.find(patron_id)
  copy_id = params.fetch('copies_id')
  @patron.update({:copies_id => copy_id})
  @copies = Copy.all()
  erb(:patron_info)
end

delete("/copies/:id") do
  @copy = Copy.find(params.fetch("id").to_i())
  @copy.delete()
  @copies = Copy.all()
  erb(:success)
end
