require 'questions'
require 'rspec'
require 'pg'
require 'pry'

DB = PG.connect({:dbname => 'quiz_maker_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM albums *;")
    DB.exec("DELETE FROM songs *;")
  end
end