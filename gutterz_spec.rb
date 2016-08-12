# Test drive development woot!
# Expected inputs and outputs for basic functions I will need

require_relative 'gutterz'
require 'sqlite3'
require_relative 'table_maker'
DB.results_as_hash = true

describe Gutterz do
    let(:gutterz) { DummyUpdate.new { include Update } }
# Input: a publisher's name
# Output, read it back
    it "adds a publisher's name to the publisher table" do
        
    end

# Input: a writer's name
# Output: I want to make sure I can read it back from the table

# Input: an artist's name
# Output: Read it back

# Input: a colorist's name
# Output: Read it back

# Input: a genre
# Output: read it back

# Input: a title
# Output : read it back

# Input: an issue 
# Output: make sure that the join actually reads back correctly

end