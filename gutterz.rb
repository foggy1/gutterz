# Begin by hardcoding the generation of our tables so we can mess
# around with them and never have to type all this CREATE TABLE
# nonsense again.

require 'sqlite3'

# Let's make a database
db = SQLite3::Database.new("gutterz.db")
db.results_as_hash = true

# Let's heredoc a buttload of create tables
create_issue_table = <<-SQL
    CREATE TABLE IF NOT EXISTS issues (
        id INTEGER PRIMARY KEY,
        number INT,
        schedule VARCHAR(255),
        cover_price INT,
        resale INT,
        quantity INT,
        title_id INT,
        writer_id INT,
        artist_id INT,
        publisher_id INT,
        colorist_id INT,
        genre_id INT,
        FOREIGN KEY (title_id) REFERENCES titles(id),
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
        year_start INT,
        year_end INT
    )
SQL

create_writer_table = <<-SQL
    CREATE TABLE IF NOT EXISTS writers (
        id INTEGER PRIMARY KEY,
        name VARCHAR(255)
    )
    SQL

create_artist_table = <<-SQL
    CREATE TABLE IF NOT EXISTS artists (
        id INTEGER PRIMARY KEY,
        name VARCHAR(255)
    )
    SQL

create_colorist_table = <<-SQL
    CREATE TABLE IF NOT EXISTS colorists (
        id INTEGER PRIMARY KEY,
        name VARCHAR(255)
    )
    SQL


create_publisher_table = <<-SQL
    CREATE TABLE IF NOT EXISTS publishers (
        id INTEGER PRIMARY KEY,
        name VARCHAR(255)
    )
    SQL

create_genre_table = <<-SQL
    CREATE TABLE IF NOT EXISTS genres (
        id INTEGER PRIMARY KEY,
        name VARCHAR(255)
    )
    SQL


#test this table creation
db.execute(create_issue_table)
db.execute(create_publisher_table)
db.execute(create_writer_table)
db.execute(create_artist_table)
db.execute(create_colorist_table)
db.execute(create_genre_table)
db.execute(create_title_table)