module SQLParser
  
  def self.read_table
    floppy_args_symbol_keys = []
    floppy_args = DB.execute(BASIC_INFO_VIEW) do |row|
      # binding.pry
      floppy_args_symbol_keys << row.inject({}){ |hash,(key,value)| if key.is_a?(String) then hash[key.to_sym] = value end; hash }
    end 
    floppy_args_symbol_keys
  end
end