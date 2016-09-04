module FloppyFactory
  def self.make(floppy_args)
    floppy_args.each { |args| Floppy.new(args) }
  end
end