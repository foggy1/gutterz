module ComicSearch
  
  def self.basic_search(floppies, title, issue_number)
    floppies.select{ |floppy| floppy.title == title && issue_number }
  end

  def self.narrow_it_down(search_results)
    # search_results.select()
  end


end