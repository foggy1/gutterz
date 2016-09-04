module ComicCollector
  
  def self.add_floppy(new_floppy)
    # title, year, issue_number, writer, artist, publisher, genre, schedule, quantity, price = info_array
    # Make sure we don't already have the comic, offer to add more copies if we do
    # if get_id(title, year, issue_number, schedule)
    #     comic_id = get_id(title, year, issue_number, schedule)
    #     update_quantity(comic_id)
    #     return
    # end
    # First insert compartmentalized values into their respective tables
    DB.execute("INSERT OR IGNORE INTO titles (title) VALUES (?)", [new_floppy.title])
    DB.execute("INSERT OR IGNORE INTO years(year) VALUES (?)", [new_floppy.year])
    DB.execute("INSERT OR IGNORE INTO writers (writer) VALUES (?)", [new_floppy.writer])
    DB.execute("INSERT OR IGNORE INTO artists (artist) VALUES (?)", [new_floppy.artist])
    DB.execute("INSERT OR IGNORE INTO publishers (publisher) VALUES (?)", [new_floppy.publisher])
    DB.execute("INSERT OR IGNORE INTO genres (genre) VALUES (?)", [new_floppy.genre])
    DB.execute("INSERT OR IGNORE INTO schedules (schedule) VALUES (?)", [new_floppy.schedule])
    # Then grab the relevant id's to be foreign keys0]0]
    title_id = DB.execute("SELECT id FROM titles WHERE title=(?)", [new_floppy.title])[0][0]
    year_id = DB.execute("SELECT id FROM years WHERE year=(?)", [new_floppy.year])[0][0]
    writer_id = DB.execute("SELECT id FROM writers WHERE writer=(?)", [new_floppy.writer])[0][0]
    artist_id = DB.execute("SELECT id FROM artists WHERE artist=(?)", [new_floppy.artist])[0][0]
    publisher_id = DB.execute("SELECT id FROM publishers WHERE publisher=(?)", [new_floppy.publisher])[0][0]
    genre_id = DB.execute("SELECT id FROM genres WHERE genre=(?)", [new_floppy.genre])[0][0]
    schedule_id = DB.execute("SELECT id FROM schedules WHERE schedule=(?)", [new_floppy.schedule])[0][0]
    # Then put it all together in the issue table
     # binding.pry
    DB.execute("INSERT INTO issues (title_id, year_id, number, writer_id, artist_id, publisher_id, genre_id,
                       schedule_id, quantity, cover_price)
                       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                       [title_id, year_id, new_floppy.issue_number, writer_id, artist_id, publisher_id, genre_id, schedule_id, 
                        new_floppy.quantity, new_floppy.cover_price])
  end


def self.update_database(floppies)
  floppies.each { |floppy| add_floppy(floppy) }
end

end