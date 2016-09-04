require_relative 'series'
# Dedicated class for a single comic issue or, "floppy"
class Floppy < Series
    def post_initialize(args)
        @cover_price = args.fetch(:cover_price)
        @resale = args.fetch(:resale, nil)
        @quantity = args.fetch(:quantity, 1)
        @writer = args.fetch(:writer)
        @artist = args.fetch(:artist)
        @colorist = args.fetch(:colorist, nil)
    end
end