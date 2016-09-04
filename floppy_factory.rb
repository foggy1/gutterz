module FloppyFactory
  
  def self.make(floppy_args)
    floppy_args.map{ |args| Floppy.new(args) }
  end

  def 

end