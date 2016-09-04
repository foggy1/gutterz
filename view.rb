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

end