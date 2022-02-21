#!/usr/bin/python3

# This small script shall prepare some data from the sqlite3 database "mylibrary.db".
# The data itself is supplied via text files (book and author).
# The separation is because of ease getting the desired result.
#
# sqlite3 steps:
# sqlite> .mode list
# sqlite> .separator |
# sqlite> .output books.txt
# sqlite> SELECT id,author,title,series FROM book;
# sqlite> .output authors.txt
# sqlite> SELECT id,lastname,firstname FROM author ORDER BY author.lastname;
#
# If the data should be in one file:
# sqlite> SELECT author.lastname,author.firstname,book.title,book.series FROM author, book WHERE book.author = author.id ORDER BY author.lastname;
#
# Process:
# Go line for line through "authors.txt" and search the respective books in "books.txt". (not very efficient, I know)
# And apply some specific formatting:
# ### Lastname, Firstname
# * Item (Series)
# As long the current run through "books.txt" isn't finished, nothing is written to the final file.


def prep_author(curr_author):
    # Roughly prepare the line: Author-ID and stitch the names together
    tmp = curr_author.split('|')
    return tmp[0], tmp[1]+', '+tmp[2]

def prep_book(curr_book):
    # Split line into author-ID, title and series
    tmp = curr_book.split('|')
    return tmp[1], tmp[2], tmp[3]

def formatting_author(name):
    # Prepend Gemini header
    return '### '+name

def formatting_book(title, series):
    # Series, how the database stores it: [{"title":"Stardust","volume":1.0}] <- JSON, TOML? Something like that
    series = series.replace("[{\"title\":\"", " (").replace("\",\"volume\":", ' ').replace("}]\n", ")")
    if len(series) > 1:
        return '* '+title+series
    else:
        return '* '+title

def main():
    # Classical I-loop-through-everything
    # Inefficient as hell, but I don't care at the moment.
    # For better performance: per regex the respective books with the fitting author-id
    authors = "authors.txt"
    books = "books.txt"
    gmitext = "booklist_new.gmi"

    # Work with the retrieved data
    try:
        with open(gmitext, "w") as final:
            with open(authors, "r") as a:
                for aline in a:
                    aid, name = prep_author(aline)
                    name = formatting_author(name)

                    with open(books, "r") as b:
                        bookcount = 0
                        titles = []
                        for bline in b:
                            b_aid, title, series = prep_book(bline)
                            if (aid == b_aid):
                                bookcount += 1
                                book_entry = formatting_book(title, series)
                                titles.append(book_entry)
                        if (bookcount > 0):
                            final.write(name)
                            for entry in titles:
                                final.write(entry+'\n')
                            final.write('\n')
    except:
        print("Something went wrong and the author was to lazy to include proper error handling")

if __name__ == '__main__':
    main()
