# Begin by hardcoding the generation of our tables so we can mess
# around with them and never have to type all this CREATE TABLE
# nonsense again.

require 'sqlite3'
require_relative 'table_maker'
DB.results_as_hash = true
# DB.execute('INSERT INTO writers (name) VALUES ("Grant Morrison")')
writers = DB.execute('SELECT * FROM writers')
puts writers