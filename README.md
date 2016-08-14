# gutterz
a comic collection organizer

For a DBC project, I have to use Ruby and SQL to 
make a program that takes advantage of persistent data.  And you know what?

I **desperately** need a better way to keep track of my comics.

I own probably ~1000 single issues, including several hundred X-Men comics.  Independent of the fact that none of my friends are going to want to help me move, there are a few problems with this.  First of all, just with that number, it's obviously hard to keep track of individual items.  And it's hard in two senses: it's hard to remember what I have, and when I try to make lists to remember, it's a laborious process entering one item at a time.

The second big problem is that if I want to know if I own *Uncanny X-Men 267* I have to scroll through a hard-to-read list to see if it's missing (looking at the cover I think I *might* have it).  Even if I take the time to make a dedicated list of things I'm missing, that list will also be hard to read, and will be prone to at least twice the amount of human error.

So then **gutterz**, affectionately named for the space between comic panels (while also being a nod to the fact that I need to get my comic organization act cleaned up) has two big goals I'm aiming for:

1. I want it to be easier to enter issues of comics, with meta-data, in bulk, in several different ways.

2. I want to be able to easily search whether or not I have an issue.

I might add some more features and some might just emerge from how I set up the database.  But these are my initial thoughts on **gutterz**.

## gutterz 1.0 (August 13th)
As of this date **gutterz** can perform two basic functions: it can add a comic to a database with rudimentary info and it can view any single issue within the database according to a title and issue number.  It can also sort out an exception for each of those functions: if you attempt to add a title that is already in the database, **gutterz** will offer to allow you to increase the quantity value of that title instead.  

Additionally, because the people running Marvel and DC are not that bright sometimes, there are several different editions of a comic with the same title and number (think X-Men #4 from back in the 1960's and X-Men #4 from Brian Wood's run a few years ago).  I don't want to make the user enter twenty things to get to an issue, so if there is more than one instance of, say, X-Men #4, **gutterz** will catch it, list all of those instance for you, and allow you to select the one that you meant via an identifying value.

## Plans for future updates
- Automate entry for a range of values (let the user enter a range of, say, 25-50 and enter all those X-men issues at once)
- Add writer, artist, publisher, and genre searches
- Automate a function that will tell me which issues are missing in some range of some title
- Clean up the code because it is morally obligatory once you've seen it
