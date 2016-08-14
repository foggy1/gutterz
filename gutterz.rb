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
                                  select titles.name, years.year, issues.number, 
                                  writers.name, artists.name, publishers.name, genres.name, schedules.name,
                                  issues.quantity, issues.cover_price from titles join years on years.id = issues.year_id
                                  join issues on titles.id = issues.title_id join writers on issues.writer_id = writers.id join 
                                  artists on issues.artist_id = artists.id join publishers on 
                                  issues.publisher_id = publishers.id join genres on issues.genre_id = 
                                  genres.id join schedules on schedules.id = issues.schedule_id
                          SQL


# I'm going to want every comic that gets entered to have the same
# order amount of basic data: the title, the year that title started, the comic's issue number
# the writer's name, the artist's name, the publisher's name, the genre, the quantity of that issue,
# and the cover price.  We will prompt the user for these things in turn, and then
# pass them into this function, which will be the rudimentary function by which things
# are first added to the database.
def add_a_comic
    info_array = get_info
    title, year, issue_number, writer, artist, publisher, genre, schedule, quantity, price = info_array
    # First insert compartmentalized values into their respective tables
    if get_id(title, year, issue_number, schedule)
        comic_id = get_id(title, year, issue_number, schedule)
        update_quantity(comic_id)
        return
    end
    DB.execute("INSERT OR IGNORE INTO titles (name) VALUES (?)", [title])
    DB.execute("INSERT OR IGNORE INTO years(year) VALUES (?)", [year])
    DB.execute("INSERT OR IGNORE INTO writers (name) VALUES (?)", [writer])
    DB.execute("INSERT OR IGNORE INTO artists (name) VALUES (?)", [artist])
    DB.execute("INSERT OR IGNORE INTO publishers (name) VALUES (?)", [publisher])
    DB.execute("INSERT OR IGNORE INTO genres (name) VALUES (?)", [genre])
    DB.execute("INSERT OR IGNORE INTO schedules (name) VALUES (?)", [schedule])
    # Then grab the relevant id's to be foreign keys
    title_id = DB.execute("SELECT id FROM titles WHERE name=(?)", [title])
    year_id = DB.execute("SELECT id FROM years WHERE year=(?)", [year])
    writer_id = DB.execute("SELECT id FROM writers WHERE name=(?)", [writer])
    artist_id = DB.execute("SELECT id FROM artists WHERE name=(?)", [artist])
    publisher_id = DB.execute("SELECT id FROM publishers WHERE name=(?)", [publisher])
    genre_id = DB.execute("SELECT id FROM genres WHERE name=(?)", [genre])
    schedule_id = DB.execute("SELECT id FROM schedules WHERE name=(?)", [schedule])
    # Then put it all together in the issue table
    DB.execute("INSERT INTO issues (title_id, year_id, number, writer_id, artist_id, publisher_id, genre_id,
                       schedule_id, quantity, cover_price)
                       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                       [title_id, year_id, issue_number, writer_id, artist_id, publisher_id, genre_id, schedule_id, 
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
    # if more than one pops up, we'll have an array longer than one.  In that case, we'll
    # use basic info and pick out the years and then format a string with the title and year
    # asking which one they meant.
    comic_title, year, issue_number, writer, artist, publisher, genre, schedule, quantity, price = narrow_it_down(title, number)
    if comic_title == '' || issue_number == nil
        puts "You don't own or have not entered #{title} \##{number} yet."
        puts "Try adding it or viewing something else."
        puts "~~~~"
        return
    end
    cover_price = price.to_f / 100
    puts "~~~~~~~~~~~~~~~"
    puts "#{comic_title}(#{year}) \##{issue_number}"
    puts "Writer: #{writer}"
    puts "Artist: #{artist}"
    puts "Publisher: #{publisher}"
    puts "Genre: #{genre}"
    puts "Type: #{schedule}"
    puts "Copies: #{quantity}"
    puts "Cover price: #{cover_price}"
    puts "~~~~~~~~~~~~~~~"
end

# Functionally decompose the part of the comic viewing method where
# we ask the user to narrow it down
def narrow_it_down(title, number)
    narrow_comic_search = DB.execute(BASIC_INFO_VIEW + " WHERE titles.name = (?) and issues.number = (?)", [title, number])
    if narrow_comic_search.length > 1
        
        puts "Whoops! You have that issue number from more than one series!"
        narrow_comic_search.each do |comic|
             title, year, issue_number, schedule = comic[0], comic[1], comic[2], comic[7]
             current_id = get_id(title, year, issue_number, schedule)
             puts "#{current_id}: #{title}(#{year}) #{issue_number} #{schedule}"
        end
        puts "Which exact series did you want that issue from (enter its index number to the left)?: "
        index = gets.to_i
        comic = DB.execute(BASIC_INFO_VIEW + " WHERE issues.id = (?)", [index])
        return comic[0]
    else
        comic = narrow_comic_search
        return comic[0]
    end
end

# Take in all the data from the user that's needed to add a comic
# Check that that data, in its array form, does not already exist in our database as such
# If it does, we'll prompt the user to either update the quantity of that item
# or re-enter the info

# def comic_exists?(title, year, issue_number, writer, artist, publisher, genre, schedule, quantity, price)
#     comics = DB.execute(BASIC_INFO_VIEW)
#     if comics.index([title, year, issue_number, writer, artist, publisher, genre, schedule, quantity, price])
#         return true
#     end
# end

# Need a function that updates the quantity of a single issue
# It will need all the basic identifying issue info
def update_quantity(comic_id)
    title, year, number, quantity = DB.execute("select titles.name, years.year, issues.number, issues.quantity
                                  from titles join years on years.id = issues.year_id
                                  join issues on titles.id = issues.title_id join writers on issues.writer_id = writers.id join 
                                  artists on issues.artist_id = artists.id join publishers on 
                                  issues.publisher_id = publishers.id join genres on issues.genre_id = 
                                  genres.id join schedules on schedules.id = issues.schedule_id WHERE issues.id = (?)", [comic_id])[0]
    puts "You already have #{quantity} copies of #{title} (#{year}) \##{number}."
    print "How many copies of #{title} (#{year}) \##{number} do you want to add (or type 'none')? "
    add_quantity = gets.chomp
    if add_quantity == 'none'
        return false
    else
        add_quantity_int = add_quantity.to_i
        quantity += add_quantity_int
    end
    DB.execute("UPDATE issues SET quantity = (?) WHERE id = (?)", [quantity, comic_id])
end

# Need a function that gets the id of a specific comic issue
# Working with an id will just be so much better than anything else
# No two comics will ever have the same title, year, issue number, AND schedule
# Those things together essentially define a single issue as being a single issue
# So those values passed into this function will suffice.
def get_id(title, year, issue_number, schedule)
    title_id = DB.execute("SELECT id FROM titles WHERE name=(?)", [title])
    year_id = DB.execute("SELECT id FROM years WHERE year=(?)", [year])
    schedule_id = DB.execute("SELECT id FROM schedules WHERE name=(?)", [schedule])
    comic_id = DB.execute("select id from issues where title_id = (?) and year_id = (?) and number = (?) and schedule_id = (?)", 
                                       [title_id, year_id, issue_number, schedule_id])
    if comic_id[0] == nil
        return nil
    else
        return comic_id[0][0]
    end
end

def get_info
    print "Title: "
    title = gets.chomp
    print "Year this title began serialization: "
    year = gets.to_i
    print "Issue number: "
    number = gets.to_i
    puts "Note: please enter multiple writers or artists alphabetically by last name, separated by commas."
    print "Writer(s): "
    writer = gets.chomp
    print "Artist(s): "
    artist = gets.chomp
    print "Publisher: "
    publisher = gets.chomp
    print "Genre (e.g. Superhero, Sci-fi, Autobio, Cartoon): "
    genre = gets.chomp
    print "Publishing schedule (e.g. Ongoing, Limited, One-shot): "
    schedule = gets.chomp
    print "How many copies: "
    quantity = gets.to_i
    print "Cover price in cents: "
    price = gets.to_i
    return title, year, number, writer, artist, publisher, genre, schedule, quantity, price
end

# TEST CODE

# num = DB.execute('select id from writers where name="Grant Morrison"')[0][0]
# p num

# add_a_comic("Superman", 1938, 512, "Karl Kesel", "Barry Kitson", "DC", "Superhero", "Ongoing",
#                      1, 150)
# add_a_comic("Superman", 1938, 513, "Karl Kesel, Barry Kitson", "Barry Kitson", "DC", "Superhero", "Ongoing",
#                      1, 150)
# add_a_comic("Superman", 2013, 1, "Jeff Parker", "Chris Samnee", "DC", "Superhero", "Ongoing",
#                      1, 399)
# add_a_comic("Superman", 1938, 1, "Jeff Parker", "Chris Samnee", "DC", "Superhero", "Ongoing",
                     # 1, 399)


# comics = DB.execute(BASIC_INFO_VIEW)
# comics.each { |issue| puts issue.join' '}
# p comics[0]
# p comics.index(["Superman", 2013, 1, "Jeff Parker", "Chris Samnee", "DC", "Superhero", "Ongoing",
#                      1, 399])
# p comics.index([4])

# p get_id("Superman", 2013, 1, "Ongoing")
# update_quantity(3)
# p get_id("Nah tho", 2, 4, "poops")

# p view_a_comic

## DRIVER CODE
puts "Welcome to Gutterz 1.0!"
if DB.execute("SELECT * FROM issues") == []
    
    puts "Currently you can add a comic and view the info of any single issues you have added!"
    puts "~~~~"
    puts "Please add your first comic!"
    puts "~~~~"
    add_a_comic
end
loop do
    print "Add or view (type 'add', 'view', or 'exit')? "
    operation = gets.chomp
    if operation == 'add'
        add_a_comic
    elsif operation == 'view'
        view_a_comic
    elsif operation == 'exit'
        exit
    else
        puts "Please limit your inputs to 'add' or 'view' for now."
        redo
    end
end