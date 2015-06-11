#!/usr/bin/env python3
#
# leo -- Look something up on
# leo.org
#
# Dep: local lib: geturl.py
#

import sys
import re
from shutil import get_terminal_size
from textwrap import wrap
from lib.py import geturl
from urllib.parse import quote

# Remove unnecessary chars
def removechars(liste):
    for k in range(0, len(liste)):
        liste[k] = liste[k].replace("lang=\"de\">", '')
        liste[k] = liste[k].replace("lang=\"en\">", '')
        liste[k] = liste[k].replace("<small>", '')
        liste[k] = liste[k].replace("</small>", '')
        liste[k] = liste[k].replace("<i>", '')
        liste[k] = liste[k].replace("</i>", '')
        liste[k] = liste[k].replace("\n</td>", '')
        liste[k] = liste[k].replace("</td>", '')
        liste[k] = liste[k].replace("<b>", '')
        liste[k] = liste[k].replace("</b>", '')
        liste[k] = liste[k].replace("\n", '')

    return liste

# --- Main ---
# If nothing is given in the command line; exit
if len(sys.argv) < 2:
    print("Usage: leo WORD[S]")
    sys.exit(1)

INPUT = sys.argv[1:]

# Convert list to str
# and if more than one word is given
# they're joined with a +
INPUT = '+'.join(INPUT)

# Encode INPUT to URL compatible ASCII and create search url (ende)
search = "/dictQuery/m-vocab/ende/de.html?searchLoc=0&lp=ende&lang=de&directN=0&search="+quote(INPUT)+"&resultOrder=basic&multiwordShowSingle=on"

# Connect to page and request result.
url = "dict.leo.org"
conn = geturl.connectto(url, search)

# Check, get result and parse it
res, status = geturl.checkresponse(conn, url)
if status == 404:
    resblock = re.search("<div class.*</tr></tbody>", res, re.DOTALL)
    possible = re.findall("link\">.*?/span>", resblock.group())
    possible = list(set(possible)) # Get rid of duplicates
    print("\n'%s' couldn't be found.\nDid you mean one of the following?\n" % (INPUT.replace('+', ' ')))
    for i in range(0, len(possible)):
        print("  \u00bb{}".format(possible[i][6:-7]))
else:
    resblock = re.search("tbody>.*</tbody", res, re.DOTALL)

    meaning = re.findall("lang=\"de\">.*?</td>", resblock.group(), re.DOTALL)
    meaning_en = re.findall("lang=\"en\">.*?</td>", resblock.group(), re.DOTALL)

    # Remove unnecessary chars
    meaning = removechars(meaning)
    meaning_en = removechars(meaning_en)

    # Set the printing to max 10
    if len(meaning) > 10:
        anz = 10
    else:
        anz = len(meaning)

    # Print the result
    term_col = get_terminal_size().columns
    print("\n'%s' could stand for the following:\n" % (INPUT.replace('+', ' ')))
    for i in range(0, anz):
        meaning_wrap = wrap(meaning[i], width=term_col-10)
        meaning_en_wrap = wrap(meaning_en[i], width=term_col-10)
        print("{0:2d}: ".format(i+1), end="")
        print("\n\t \u25ba ".join("%s\n    \u25ba\u25ba %s" % t for t in zip(meaning_wrap,meaning_en_wrap)))
