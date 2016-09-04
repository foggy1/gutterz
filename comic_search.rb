module ComicSearch
  
  def self.basic_search(floppies, title, issue_number)
    floppies.select{ |floppy| floppy.title == title && floppy.issue_number == issue_number }
  end

  def self.narrow_it_down(search_results)
    # search_results.select()
  end

    def self.already_own?(new_args, floppies)
      binding.pry
      already_owned = floppies.select { |floppy| new_args[:title] == floppy.title &&
                                                  new_args[:year] == floppy.year &&
                                                  new_args[:number] == floppy.issue_number &&
                                                  new_args[:schedule] == floppy.schedule
                                  }.length
      already_owned > 0
    end

end