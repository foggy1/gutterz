module SQLParser
  
  def self.read_table
    floppy_args_symbol_keys = []
    floppy_args = DB.execute(BASIC_INFO_VIEW) do |row|
      # binding.pry
      floppy_args_symbol_keys << row.inject({}){ |hash,(key,value)| if key.is_a?(String) then hash[key.to_sym] = value end; hash }
    end 
    floppy_args_symbol_keys
  end

  def self.update_quantity(floppy, new_quantity)
    DB.execute("UPDATE issues
                            SET issues.quantity = (?)
                            WHERE title_id IN
                            (SELECT title_id  from titles join years on years.id = issues.year_id
                                      join issues on titles.id = issues.title_id 
                                      join writers on issues.writer_id = writers.id 
                                      join artists on issues.artist_id = artists.id 
                                      join publishers on issues.publisher_id = publishers.id 
                                      join genres on issues.genre_id = genres.id 
                                      join schedules on schedules.id = issues.schedule_id
                                      WHERE titles.title = floppy.title
  end

end