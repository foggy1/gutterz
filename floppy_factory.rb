module FloppyFactory
  
  def self.make(floppy_args)
    floppy_args.map{ |args| Floppy.new(args) }
  end

 # Add function that adds single issues, use that to populate instead

end