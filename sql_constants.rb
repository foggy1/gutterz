# Begin by hardcoding the generation of our tables so we can mess
# around with them and never have to type all this CREATE TABLE
# nonsense again.
    DB = SQLite3::Database.new("gutterz.db")
    
    # Let's heredoc a buttload of create tables
    CREATE_ISSUE_TABLE = <<-SQL
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

    CREATE_TITLE_TABLE = <<-SQL
        CREATE TABLE IF NOT EXISTS titles (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255),
            UNIQUE(name)
        )
    SQL

    CREATE_YEAR_TABLE = <<-SQL
        CREATE TABLE IF NOT EXISTS years (
            id INTEGER PRIMARY KEY,
            year INT,
            UNIQUE(year)
        )
    SQL

    CREATE_SCHEDULE_TABLE = <<-SQL
        CREATE TABLE IF NOT EXISTS schedules (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255),
            UNIQUE(name)
        )
    SQL

    CREATE_WRITER_TABLE = <<-SQL
        CREATE TABLE IF NOT EXISTS writers (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255),
            UNIQUE(name)
        )
        SQL

    CREATE_ARTIST_TABLE = <<-SQL
        CREATE TABLE IF NOT EXISTS artists (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255),
            UNIQUE(name)
        )
        SQL

    CREATE_COLORIST_TABLE = <<-SQL
        CREATE TABLE IF NOT EXISTS colorists (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255),
            UNIQUE(name)
        )
        SQL


    CREATE_PUBLISHER_TABLE = <<-SQL
        CREATE TABLE IF NOT EXISTS publishers (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255),
            UNIQUE(name)
        )
        SQL

    CREATE_GENRE_TABLE = <<-SQL
        CREATE TABLE IF NOT EXISTS genres (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255),
            UNIQUE(name)
        )
        SQL

    BASIC_INFO_VIEW = <<-SQL
                                      select titles.name, years.year, issues.number, 
                                      writers.name, artists.name, publishers.name, genres.name, schedules.name,
                                      issues.quantity, issues.cover_price 
                                      from titles join years on years.id = issues.year_id
                                      join issues on titles.id = issues.title_id 
                                      join writers on issues.writer_id = writers.id 
                                      join artists on issues.artist_id = artists.id 
                                      join publishers on issues.publisher_id = publishers.id 
                                      join genres on issues.genre_id = genres.id 
                                      join schedules on schedules.id = issues.schedule_id
                              SQL