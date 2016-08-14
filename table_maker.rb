# Begin by hardcoding the generation of our tables so we can mess
# around with them and never have to type all this CREATE TABLE
# nonsense again.

require 'sqlite3'


    DB = SQLite3::Database.new("gutterz.db")
    
    # Let's heredoc a buttload of create tables
    create_issue_table = <<-SQL
        CREATE TABLE IF NOT EXISTS issues (
            id INTEGER PRIMARY KEY,
            number INT,
            schedule_id INT,
            cover_price INT,
            resale INT,
            quantity INT,
            title_id INT,
            year_id INT,
            writer_id INT,
            artist_id INT,
            publisher_id INT,
            colorist_id INT,
            genre_id INT,
            FOREIGN KEY (schedule_id) REFERENCES schedules(id),
            FOREIGN KEY (title_id) REFERENCES titles(id),
            FOREIGN KEY (year_id) REFERENCES years(id),
            FOREIGN KEY (writer_id) REFERENCES writers(id),
            FOREIGN KEY (artist_id) REFERENCES artists(id),
            FOREIGN KEY (publisher_id) REFERENCES publishers(id),
            FOREIGN KEY (colorist_id) REFERENCES colorists(id)
        )
    SQL

    create_title_table = <<-SQL
        CREATE TABLE IF NOT EXISTS titles (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255),
            UNIQUE(name)
        )
    SQL

    create_year_table = <<-SQL
        CREATE TABLE IF NOT EXISTS years (
            id INTEGER PRIMARY KEY,
            year INT,
            UNIQUE(year)
        )
    SQL

    create_schedule_table = <<-SQL
        CREATE TABLE IF NOT EXISTS schedules (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255),
            UNIQUE(name)
        )
    SQL

    create_writer_table = <<-SQL
        CREATE TABLE IF NOT EXISTS writers (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255),
            UNIQUE(name)
        )
        SQL

    create_artist_table = <<-SQL
        CREATE TABLE IF NOT EXISTS artists (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255),
            UNIQUE(name)
        )
        SQL

    create_colorist_table = <<-SQL
        CREATE TABLE IF NOT EXISTS colorists (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255),
            UNIQUE(name)
        )
        SQL


    create_publisher_table = <<-SQL
        CREATE TABLE IF NOT EXISTS publishers (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255),
            UNIQUE(name)
        )
        SQL

    create_genre_table = <<-SQL
        CREATE TABLE IF NOT EXISTS genres (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255),
            UNIQUE(name)
        )
        SQL


    #test this table creation
    DB.execute(create_issue_table)
    DB.execute(create_publisher_table)
    DB.execute(create_writer_table)
    DB.execute(create_artist_table)
    DB.execute(create_colorist_table)
    DB.execute(create_genre_table)
    DB.execute(create_title_table)
    DB.execute(create_year_table)
    DB.execute(create_schedule_table)