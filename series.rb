# Class for a comics series; so, Uncanny X-Men(1963)
class Series
    def initialize(args={})
        @title = args.fetch(:title)
        @year = args.fecth(:year)
        @floppies = args.fetch(:floppies)
        @total_issues = args.fetch(:total_issues, nil)
    end
end

# Note to self: this would be an intermediary class if we decided to also include TPB's or manga in the future
# We could move publisher, title, genre, and year up the chain; schedule might disappear at that point for the others,
# as schedule is implied by their format.