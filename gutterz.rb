# Begin by hardcoding the generation of our tables so we can mess
# around with them and never have to type all this CREATE TABLE
# nonsense again.

require 'sqlite3'
require_relative 'table_maker'
DB.results_as_hash = true
# DB.execute('INSERT INTO writers (name) VALUES ("Grant Morrison")')
# writers = DB.execute('SELECT * FROM writers')
# p writers

a_comic = DB.execute('select titles.name, titles.year_start, issues.number, writers.name, artists.name, publishers.name, genres.name,  issues.quantity, issues.cover_price from titles join issues on titles.id = issues.title_id join writers on issues.writer_id = writers.id join artists on issues.artist_id = artists.id join publishers on issues.publisher_id = publishers.id join genres on issues.genre_id = genres.id;
')
p a_comic