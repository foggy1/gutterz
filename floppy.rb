# Dedicated class for a single comic issue or, "floppy"
class Floppy
    def initialize(args={})
        @schedule = args.fetch(:schedule)
        @cover_price = args.fetch(:cover_price)
        @resale = args.fetch(:resale, nil)
        @quantity = args.fetch(:quantity, 1)
        @title = args.fetch(:title)
        @year = args.fetch(:year)
        @writer = args.fetch(:writer)
        @artist = args.fetch(:artist)
        @publisher = args.fetch(:publisher)
        @colorist = args.fetch(:colorist, nil)
        @genre = args.fetch(:genre)
    end
end