# Begin by hardcoding the generation of our tables so we can mess
# around with them and never have to type all this CREATE TABLE
# nonsense again.

require 'sqlite3'
require_relative 'table_maker'
# DB.results_as_hash = true
# DB.execute('INSERT INTO writers (name) VALUES ("Grant Morrison")')
# writers = DB.execute('SELECT * FROM writers')
# p writers


BASIC_INFO_VIEW = <<-SQL
                                  select titles.name, titles.year_start, issues.number, 
                                  writers.name, artists.name, publishers.name, genres.name, issues.schedule,
                                  issues.quantity, issues.cover_price from titles join issues on 
                                  titles.id = issues.title_id join writers on issues.writer_id = writers.id join 
                                  artists on issues.artist_id = artists.id join publishers on 
                                  issues.publisher_id = publishers.id join genres on issues.genre_id = 
                                  genres.id
                          SQL

# I'm going to want every comic that gets entered to have the same
# order amount of basic data: the title, the year that title started, the comic's issue number
# the writer's name, the artist's name, the publisher's name, the genre, the quantity of that issue,
# and the cover price.  We will prompt the user for these things in turn, and then
# pass them into this function, which will be the rudimentary function by which things
# are first added to the database.
def add_a_comic(title, year, issue_number, writer, artist, publisher, genre, schedule, quantity, price)
    # First insert compartmentalized values into their respective tables
    DB.execute("INSERT INTO titles (name, year_start) VALUES (?, ?)", [title, year])
    DB.execute("INSERT OR IGNORE INTO writers (name) VALUES (?)", [writer])
    DB.execute("INSERT OR IGNORE INTO artists (name) VALUES (?)", [artist])
    DB.execute("INSERT INTO publishers (name) VALUES (?)", [publisher])
    DB.execute("INSERT INTO genres (name) VALUES (?)", [genre])
    # Then grab the relevant id's to be foreign keys
    title_id = DB.execute("SELECT id FROM titles WHERE name=(?) AND year_start=(?)", [title, year])
    writer_id = DB.execute("SELECT id FROM writers WHERE name=(?)", [writer])
    artist_id = DB.execute("SELECT id FROM artists WHERE name=(?)", [artist])
    publisher_id = DB.execute("SELECT id FROM publishers WHERE name=(?)", [publisher])
    genre_id = DB.execute("SELECT id FROM genres WHERE name=(?)", [genre])
    # Then put it all together in the issue table
    DB.execute("INSERT INTO issues (title_id, number, writer_id, artist_id, publisher_id, genre_id,
                       schedule, quantity, cover_price)
                       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                       [title_id, issue_number, writer_id, artist_id, publisher_id, genre_id, schedule, 
                        quantity, price])
end

# Let's add a function to make single issue data readable
# We'll have to prompt them for what title they'd like to view and what number
# If there are two distinct runs of the comic with that title and number, then we'll prompt
# them to pick the edition they're talking about based on its start date
def view_a_comic
    print "What comic would you like to view? Enter its title: "
    title = gets.chomp
    print "What issue number? "
    number = gets.to_i
    narrow_comic_search = BASIC_INFO_VIEW + ' WHERE '
end


# TEST CODE

# num = DB.execute('select id from writers where name="Grant Morrison"')[0][0]
# p num

add_a_comic("Superman", 1938, 512, "Karl Kesel", "Barry Kitson", "DC", "Superhero", "Ongoing",
                     1, 150)
add_a_comic("Superman", 1938, 513, "Karl Kesel, Barry Kitson", "Barry Kitson", "DC", "Superhero", "Ongoing",
                     1, 150)
add_a_comic("Superman", 2013, 1, "Jeff Parker", "Chris Samnee", "DC", "Superhero", "Ongoing",
                     1, 399)


comics = DB.execute(BASIC_INFO_VIEW)
p comics

p BASIC_INFO_VIEW + 'where'