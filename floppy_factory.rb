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
  floppy_args = Hash[almost_args]
  floppy_args[:year] = floppy_args[:year].to_i
  floppy_args[:number] = floppy_args[:number].to_i
  floppy_args[:quantity] = floppy_args[:quantity].to_i
  floppy_args[:cover_price] = floppy_args[:cover_price].to_i
  floppy_args
  # binding.pry
 end

end