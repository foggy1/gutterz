module ComicCollector
  
  def self.add_comic
    title, year, issue_number, writer, artist, publisher, genre, schedule, quantity, price = info_array
    # Make sure we don't already have the comic, offer to add more copies if we do
    if get_id(title, year, issue_number, schedule)
        comic_id = get_id(title, year, issue_number, schedule)
        update_quantity(comic_id)
        return
    end
    # First insert compartmentalized values into their respective tables
    DB.execute("INSERT OR IGNORE INTO titles (title) VALUES (?)", [title])
    DB.execute("INSERT OR IGNORE INTO years(year) VALUES (?)", [year])
    DB.execute("INSERT OR IGNORE INTO writers (writer) VALUES (?)", [writer])
    DB.execute("INSERT OR IGNORE INTO artists (artist) VALUES (?)", [artist])
    DB.execute("INSERT OR IGNORE INTO publishers (publisher) VALUES (?)", [publisher])
    DB.execute("INSERT OR IGNORE INTO genres (genre) VALUES (?)", [genre])
    DB.execute("INSERT OR IGNORE INTO schedules (schedule) VALUES (?)", [schedule])
    # Then grab the relevant id's to be foreign keys
    title_id = DB.execute("SELECT id FROM titles WHERE title=(?)", [title])
    year_id = DB.execute("SELECT id FROM years WHERE year=(?)", [year])
    writer_id = DB.execute("SELECT id FROM writers WHERE writer=(?)", [writer])
    artist_id = DB.execute("SELECT id FROM artists WHERE artist=(?)", [artist])
    publisher_id = DB.execute("SELECT id FROM publishers WHERE publisher=(?)", [publisher])
    genre_id = DB.execute("SELECT id FROM genres WHERE genre=(?)", [genre])
    schedule_id = DB.execute("SELECT id FROM schedules WHERE schedule=(?)", [schedule])
    # Then put it all together in the issue table
     # binding.pry
    DB.execute("INSERT INTO issues (title_id, year_id, number, writer_id, artist_id, publisher_id, genre_id,
                       schedule_id, quantity, cover_price)
                       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                       [title_id, year_id, issue_number, writer_id, artist_id, publisher_id, genre_id, schedule_id, 
                        quantity, price])
  end
  
end