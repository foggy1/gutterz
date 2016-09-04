
require 'sqlite3'
require 'pry'
require_relative 'table_maker'
require_relative 'view'
require_relative 'controller'
require_relative 'sql_constants'
require_relative 'sql_parser'
require_relative 'floppy_factory'
require_relative 'floppy'
require_relative 'comic_search'
require_relative 'comic_collector'

Controller.new().run
# Given that there is a core cross-section of data that I want to work with, this is the master view
# that will give me all of the single issues in my collection.  I append specific WHERE constraints
# whenever I want to get more specific



# The basic info of any comic will be the same: title, year, issue number, writer, artist,
# publisher, genre, schedule, quantity and price.
# We'll then check to see if the issue exists and, if it does, prompt the user to update its quantity
# The method then inserts any new values into the foreign key tables
# It then gets those foreign keys, whether they're new or not, and puts them all in the issue table.
def add_a_comic(info_array)
    
end

# In order to view a comic, we will prompt the user for a title and issue number
# This should be a unique identifier, unless there is a limited series or earlier/later serial
# Whether it's unique is handled by the narrow it down method
# If there is no title or no issue number that corresponds, we exit this method
# Then we format all the info nicely.


# Grab all the relevant info for the database for a given title and issue number
# If these criteria return more than one item, we grab a few more characteristics to narrow it down
# Then prompt the user to enter their exact choice via its issue id
def narrow_it_down(title, number)
    narrow_comic_search = DB.execute(BASIC_INFO_VIEW + " WHERE titles.title = (?) and issues.number = (?)", [title, number])
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
    title_id = DB.execute("SELECT id FROM titles WHERE title=(?)", [title])
    year_id = DB.execute("SELECT id FROM years WHERE year=(?)", [year])
    schedule_id = DB.execute("SELECT id FROM schedules WHERE schedule=(?)", [schedule])
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
if DB.execute("SELECT * FROM issues") == []
    
    puts "Currently you can add a comic and view the info of any single issues you have added!"
    puts "~~~~"
    puts "Please add your first comic!"
    puts "~~~~"
    info_array = new_get_info
    add_a_comic(info_array)
end


