module FloppyFactory
  
  def self.make(floppy_args)
    floppy_args.map{ |args| Floppy.new(args) }
  end

 # Add function that adds single issues, use that to populate instead

 def self.convert_to_args(info_array)
  almost_args = [[:title, :year, :number, :writer, :artist, :publisher, :genre, :schedule, :quantity, :price], info_array].transpose
  Hash[almost_args]
  binding.pry
 end

end