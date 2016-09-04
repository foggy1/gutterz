
module TableMaker

    def self.make_table
        DB.execute(CREATE_ISSUE_TABLE)
        DB.execute(CREATE_PUBLISHER_TABLE)
        DB.execute(CREATE_WRITER_TABLE)
        DB.execute(CREATE_ARTIST_TABLE)
        DB.execute(CREATE_COLORIST_TABLE)
        DB.execute(CREATE_GENRE_TABLE)
        DB.execute(CREATE_TITLE_TABLE)
        DB.execute(CREATE_YEAR_TABLE)
        DB.execute(CREATE_SCHEDULE_TABLE)
    end

end