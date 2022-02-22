#!/usr/bin/python3

# This small script shall prepare some data from the sqlite3 database "mylibrary.db".
# The data itself is retrieved from the database with only one query.
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
# Process V3:
# Get data from the sqlite3. Store curr_author and apply some specific formatting:
# ### Lastname, Firstname
# * Item (Series)
# Not much done to gather data before writing it. Just write it to the file.

import sqlite3


def get_data(database):
    # Get specific values from the author and book table from the sqlite3 database
    con = sqlite3.connect(database)
    cur = con.cursor()
    data = cur.execute('SELECT author.lastname,author.firstname,book.title,book.series FROM author, book WHERE book.author = author.id ORDER BY author.lastname').fetchall()
    con.close()
    return data

def prep_author(curr_set):
    # Roughly prepare the line: Stitch the names together and separate lastname
    if curr_set[1] is None:
        return curr_set[0]
    else:
        return curr_set[0]+', '+curr_set[1]

def prep_book(curr_set):
    # Split line into title and series
    return curr_set[2], curr_set[3]

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
    # Loop through the dataset
    database = "mylibrary.db"
    gmitext = "booklist_new.gmi"

    # Get the data from the sqlite3 database
    data = get_data(database)

    # Work with the retrieved data
    with open(gmitext, "w") as final:
        last_author = "None"
        for line in data:
            name = prep_author(line)
            if name != last_author:
                last_author = name
                name = formatting_author(name)
                final.write('\n'+name+'\n')

            title, series = prep_book(line)
            book_entry = formatting_book(title, series)
            final.write(book_entry)
            final.write('\n')

if __name__ == '__main__':
    main()
