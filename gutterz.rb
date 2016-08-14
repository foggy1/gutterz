
require 'sqlite3'
require_relative 'table_maker'
# DB.results_as_hash = true

# Given that there is a core cross-section of data that I want to work with, this is the master view
# that will give me all of the single issues in my collection.  I append specific WHERE constraints
# whenever I want to get more specific
BASIC_INFO_VIEW = <<-SQL
                                  select titles.name, years.year, issues.number, 
                                  writers.name, artists.name, publishers.name, genres.name, schedules.name,
                                  issues.quantity, issues.cover_price from titles join years on years.id = issues.year_id
                                  join issues on titles.id = issues.title_id join writers on issues.writer_id = writers.id join 
                                  artists on issues.artist_id = artists.id join publishers on 
                                  issues.publisher_id = publishers.id join genres on issues.genre_id = 
                                  genres.id join schedules on schedules.id = issues.schedule_id
                          SQL


# The basic info of any comic will be the same: title, year, issue number, writer, artist,
# publisher, genre, schedule, quantity and price.
# We'll then check to see if the issue exists and, if it does, prompt the user to update its quantity
# The method then inserts any new values into the foreign key tables
# It then gets those foreign keys, whether they're new or not, and puts them all in the issue table.
def add_a_comic(info_array)
    title, year, issue_number, writer, artist, publisher, genre, schedule, quantity, price = info_array
    # Make sure we don't already have the comic, offer to add more copies if we do
    if get_id(title, year, issue_number, schedule)
        comic_id = get_id(title, year, issue_number, schedule)
        update_quantity(comic_id)
        return
    end
        # First insert compartmentalized values into their respective tables
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

# In order to view a comic, we will prompt the user for a title and issue number
# This should be a unique identifier, unless there is a limited series or earlier/later serial
# Whether it's unique is handled by the narrow it down method
# If there is no title or no issue number that corresponds, we exit this method
# Then we format all the info nicely.
def view_a_comic
    print "What comic would you like to view? Enter its title: "
    title = gets.chomp
    print "What issue number? "
    number = gets.to_i
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

# Grab all the relevant info for the database for a given title and issue number
# If these criteria return more than one item, we grab a few more characteristics to narrow it down
# Then prompt the user to enter their exact choice via its issue id
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


# This method takes the comic id from get_id as an argument
# It then grabs the identifying info of that issue from the database with that id
# It adds the quantity you input, unless you tell it none
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

# No two comics will ever have the same title, year, issue number, AND schedule
# Those things together essentially define a single issue as being a single issue
# We get the relevant foreign keys, then find the primary key in issues where they converge
# If no info is returned, this method returns nil, otherwise, it returns the id value
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


# Use an iterator to go through each prompt for data
# Get an input each time through and add it to a specific index in an array
# if the user types 'go back' to edit something, we decrease the iterator and redo the loop
# this way, incorrect values are overwritten
def new_get_info
    puts "Please enter the relevant info as prompted."
    puts "If you make a mistake on the previous piece of info type 'go back' to re-enter."
    info_array = []
    n = 1
    until n > 10
        case n
        when 1
             print "Title: "
        when 2
            print "Year this title began serialization: "
        when 3
             print "Issue number: "
         when 4
            puts "Note: please enter multiple writers or artists alphabetically by last name, separated by commas."
            print "Writer(s): "
        when 5
            print "Artist(s): "
        when 6
            print "Publisher: "
        when 7
            print "Genre (e.g. Superhero, Sci-fi, Autobio, Cartoon): "
        when 8
            print "Publishing schedule (e.g. Ongoing, Limited, One-shot): "
        when 9
            print "How many copies: "
        when 10
            print "Cover price in cents: "
        end
        input = gets.chomp
        if input == 'go back'
            n -= 1
            redo
        end
        info_array[n-1] = input
        n += 1
    end
    return info_array
end


# After a user adds a comic, they will be prompted if they'd like to add more of that comic
# if yes, they will enter an issue range of the form low-high
# splitting that string and turning it into a range, we'll grab the info array returned by the info-getting function
# and then we'll pass all of that into the comic function while iterating the issue number argument according to that range
def add_a_batch(info_array)
    print "Would you like to add a batch of the comic you just added (y/n)? "
    answer = gets.chomp
    if answer == 'y'
        print "Please enter an issue range with a dash, (e.g. 110-117): "
        range_array = gets.chomp.split('-')
        range = (range_array[0]..range_array[1])
        title, year, issue_number, writer, artist, publisher, genre, schedule, quantity, price = info_array
        range.each do |num|
            add_a_comic([title, year, num, writer, artist, publisher, genre, schedule, quantity, price])
        end
    end
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

# p new_get_info

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
        info_array = new_get_info
        add_a_comic(info_array)
        add_a_batch(info_array)
    elsif operation == 'view'
        view_a_comic
    elsif operation == 'exit'
        exit
    else
        puts "Please limit your inputs to 'add' or 'view' for now."
        redo
    end
end

