class View
    
    def self.new_get_info
        puts "Please enter the relevant info as prompted."
        puts "If you make a mistake on the previous piece of info type 'go back' to re-enter."
        info_array = []
        n = 1
        until n > 10
            case n
            when 1
                 print "Title: "
            when 2
                print "Year this title began serialization: "
            when 3
                 print "Issue number: "
             when 4
                puts "Note: please enter multiple writers or artists alphabetically by last name, separated by commas."
                print "Writer(s): "
            when 5
                print "Artist(s): "
            when 6
                print "Publisher: "
            when 7
                print "Genre (e.g. Superhero, Sci-fi, Autobio, Cartoon): "
            when 8
                print "Publishing schedule (e.g. Ongoing, Limited, One-shot): "
            when 9
                print "How many copies: "
            when 10
                print "Cover price in cents: "
            end
            input = gets.chomp
            if input == 'go back'
                n -= 1
                redo
            end
            info_array[n-1] = input
            n += 1
        end

        return info_array
    end


    def self.view_prompt
      print "What comic would you like to view? Enter its title: "
      title = gets.chomp
      print "What issue number? "
      number = gets.to_i
      [title, number]
    end

    def self.none_found(title, issue_number)
          puts "You don't own or have not entered #{title} \##{issue_number} yet."
          puts "Try adding it or viewing something else."
          puts "~~~~"
    end

    def self.display_info(found_array, index)
      index = 0 if !index
      floppy = found_array[index]
      puts "~~~~~~~~~~~~~~~"
      puts "#{floppy.title}(#{floppy.year}) \##{floppy.issue_number}"
      puts "Writer: #{floppy.writer}"
      puts "Artist: #{floppy.artist}"
      puts "Publisher: #{floppy.publisher}"
      puts "Genre: #{floppy.genre}"
      puts "Type: #{floppy.schedule}"
      puts "Copies: #{floppy.quantity}"
      puts "Cover price: #{floppy.cover_price}"
      puts "~~~~~~~~~~~~~~~"
    end

    def self.too_many_found(search_results)
      puts "Whoops! You have that issue number from more than one series with that title!"
      search_results.length.times { |n| puts " #{n+1} #{search_results[n].title}(#{search_results[n].year}) \##{search_results[n].issue_number} #{search_results[n].schedule}" }
      print "Enter the number of the series you intended: "
      gets.to_i - 1
    end

    def self.add_to_existing(new_floppy)
      puts "You already have #{new_floppy.quantity} copies of #{new_floppy.title} (#{new_floppy.year}) \##{new_floppy.issue_number}."
      print "How many copies of #{new_floppy.title} (#{new_floppy.year}) \##{new_floppy.number} do you want to add (or type 'none')? "
      add_quantity = gets.to_i
    end

end