module FloppyFactory
  
  def self.new_batch(floppy_args)
    floppy_args.map{ |args| make_one(args) }
  end

  def self.make_one(floppy_args)
    Floppy.new(floppy_args)
  end

 # Add function that adds single issues, use that to populate instead

 def self.convert_to_args(info_array)
  almost_args = [[:title, :year, :number, :writer, :artist, :publisher, :genre, :schedule, :quantity, :cover_price], info_array].transpose
  Hash[almost_args]
  # binding.pry
 end

end