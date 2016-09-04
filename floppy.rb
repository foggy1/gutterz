
# Dedicated class for a single comic issue or, "floppy"
class Floppy

  attr_reader :title, :issue_number, :schedule, :publisher, :genre, :year, :cover_price, :resale, :quantity, :writer, :artist

  def initialize(args)
    @schedule = args.fetch(:schedule)
    @issue_number = args.fetch(:number)
    @title = args.fetch(:title)
    @publisher = args.fetch(:publisher)
    @genre = args.fetch(:genre)
    @year = args.fetch(:year)
    @cover_price = args.fetch(:cover_price)
    @resale = args.fetch(:resale, nil)
    @quantity = args.fetch(:quantity, 1)
    @writer = args.fetch(:writer)
    @artist = args.fetch(:artist)
        # @colorist = args.fetch(:colorist, nil)
    end
end