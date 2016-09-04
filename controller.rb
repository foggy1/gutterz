class Controller
    def initialize
      @view = View
      @table_maker = TableMaker
    end

    def run
        @table_maker.make_table
        # floppy_args = 
        
        floppies = FloppyFactory.make(SQLParser.read_table)
        # binding.pry
        puts "Welcome to Gutterz 1.1!"
        loop do
          print "Add or view (type 'add', 'view', or 'exit')? "
          operation = gets.chomp
          if operation == 'add'
            info_array = @view.new_get_info
            add_a_comic(info_array)
            add_a_batch(info_array)
         elsif operation == 'view'
         title, issue_number = @view.view_prompt
         found = ComicSearch.basic_search(floppies, title, issue_number)
         @view.none_found(title, issue_number); redo if found.length == 0
         intended_index = @view.too_many_found(found) if found.length > 1
         @view.display_info(found, intended_index)
         # binding.pry
         elsif operation == 'exit'
           exit
          else
            puts "Please limit your inputs to 'add' or 'view' for now."
          redo
        end
       end
    end
end