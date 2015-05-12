require 'rspec'
require 'pg'
require 'copy'  
require 'patron'

DB = PG.connect({:dbname => 'library'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM copies *;")
    DB.exec("DELETE FROM patrons *;")
  end
end
