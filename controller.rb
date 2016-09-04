class Controller
    def initialize
      @view = View
      @table_maker = TableMaker
    end

    def run
        table_maker.make_table
        puts "Welcome to Gutterz 1.1!"
        loop do
          print "Add or view (type 'add', 'view', or 'exit')? "
          operation = gets.chomp
          if operation == 'add'
            info_array = @view.new_get_info
            add_a_comic(info_array)
            add_a_batch(info_array)
         elsif operation == 'view'
           view_a_comic
         elsif operation == 'exit'
           exit
          else
            puts "Please limit your inputs to 'add' or 'view' for now."
          redo
        end
       end
    end
end