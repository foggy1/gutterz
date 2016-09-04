# Class for a comics series; so, Uncanny X-Men(1963)
class Series
    def initialize(args={})
        @schedule = args.fetch(:schedule)
        @title = args.fetch(:title)
        @publisher = args.fetch(:publisher)
        @genre = args.fetch(:genre)
        @year = args.fetch(:year)
        #hook message for single issues
        post_initialize(args)
    end
end

# Note to self: this would be an intermediary class if we decided to also include TPB's or manga in the future
# We could move publisher, title, genre, and year up the chain; schedule might disappear at that point for the others,
# as schedule is implied by their format.