$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'insert'

require 'pg'

require 'active_record'
class Dog < ActiveRecord::Base
end

Dog.establish_connection(adapter: 'postgresql', database: 'test_insert')

Dog.connection.execute %{DROP TABLE IF EXISTS dogs}
Dog.connection.execute %{CREATE TABLE dogs(age int, name text, breed text)}
Dog.reset_column_information
