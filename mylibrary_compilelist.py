#!/usr/bin/python3

# This small script shall prepare some data from the sqlite3 database "mylibrary.db".
# The data itself is retrieved from the database.
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
# Process V2:
# Get data from the sqlite3 and apply some specific formatting:
# ### Lastname, Firstname
# * Item (Series)
# As long the current run through "books" isn't finished, nothing is written to the final file.

import sqlite3


def get_data(database):
    # Get author and book table from the sqlite3 database
    con = sqlite3.connect(database)
    cur = con.cursor()
    a = cur.execute('SELECT id,lastname,firstname FROM author ORDER BY author.lastname').fetchall()
    b = cur.execute('SELECT id,author,title,series FROM book').fetchall()
    con.close()
    return a, b

def prep_author(curr_author):
    # Roughly prepare the line: Author-ID and stitch the names together
    if curr_author[2] is None:
        return curr_author[0], curr_author[1]
    elif curr_author[1] is None:
        return curr_author[0], curr_author[2]
    else:
        return curr_author[0], curr_author[1]+', '+curr_author[2]

def prep_book(curr_book):
    # Split line into author-ID, title and series
    return curr_book[1], curr_book[2], curr_book[3]

def formatting_author(name):
    # Prepend Gemini header
    return '### '+name

def formatting_book(title, series):
    # Series, how the database stores it: [{"title":"Stardust","volume":1.0}] <- JSON, TOML? Something like that
    if series is not None:
        series = series.replace("[{\"title\":\"", " (").replace("\",\"volume\":", ' ').replace("}]", ")")
        return '* '+title+series
    else:
        return '* '+title

def main():
    # Classical I-loop-through-everything, but this time without text files
    # Still not the most efficient, but whatever. The dataset is fairly small.
    # For better performance: per regex the respective books with the fitting author-id
    database = "mylibrary.db"
    gmitext = "booklist_new.gmi"

    # Get the data from the sqlite3 database
    authors, books = get_data(database)

    # Work with the retrieved data
    with open(gmitext, "w") as final:
        for aline in authors:
            aid, name = prep_author(aline)
            name = formatting_author(name)
            bookcount = 0
            titles = []
            for bline in books:
                b_aid, title, series = prep_book(bline)
                if (aid == b_aid):
                    bookcount += 1
                    book_entry = formatting_book(title, series)
                    titles.append(book_entry)
            if (bookcount > 0):
                final.write(name+'\n')
                for entry in titles:
                    final.write(entry+'\n')
                final.write('\n')

if __name__ == '__main__':
    main()
