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
from lib import geturl
from urllib.parse import quote
from html import unescape


def removechars(liste):
    """Remove unnecessary chars"""
    for k in range(0, len(liste)):
        #liste[k] = liste[k].replace("\n", '')
        liste[k] = liste[k].replace(str(re.search("lang=.*?>", liste[k]).group()), '')

        re_dump = re.search("<a href=.*?>", liste[k])
        if re_dump is not None:
            liste[k] = liste[k].replace(str(re_dump.group()), '')

        re_dump = re.search("<span c.*/span>", liste[k])
        if re_dump is not None:
            liste[k] = liste[k].replace(str(re_dump.group()), '')

        re_dump = re.search("<span t.*?span>", liste[k])
        if re_dump is not None:
            liste[k] = liste[k].replace(str(re_dump.group()), '/ ')

        liste[k] = liste[k].replace("<span>", '/ ')

        re_dump = "reset"
        while re_dump is not None:
            re_dump = re.search("<.*?>", liste[k])
            if re_dump is not None:
                liste[k] = liste[k].replace(str(re_dump.group()), '')

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
    possible = list(set(possible))  # Get rid of duplicates
    print("\n'{}' couldn't be found.\nDid you mean one of the following?\n"
          .format(INPUT.replace('+', ' ')))
    for i in range(0, len(possible)):
        print("  \u00bb {}".format(possible[i][6:-7]))
else:
    resblock = re.search("data-leo-search-term.*?</tr></tbody></table></div>", res, re.DOTALL)

    meaning = re.findall("lang=\"de\">.*?</td>", resblock.group(), re.DOTALL)
    meaning_en = re.findall("lang=\"en\">.*?</td>", resblock.group(), re.DOTALL)

    # Remove unnecessary chars
    meaning = removechars(meaning)
    meaning_en = removechars(meaning_en)

    for item in range(0, len(meaning)):
        meaning[item] = unescape(meaning[item])
        meaning_en[item] = unescape(meaning_en[item])

    # Set the printing to max 10
    anz = 10 if len(meaning) > 10 else len(meaning)

    # Print the result
    term_col = get_terminal_size().columns
    print("\n'{}' could stand for the following:\n"
          .format(INPUT.replace('+', ' ')))
    for i in range(0, anz):
        meaning_wrap = wrap(meaning[i], width=term_col-10)
        meaning_en_wrap = wrap(meaning_en[i], width=term_col-10)
        print("{0:2d}: \u25c4\u25c4 ".format(i+1), end="")
        print("\n    \u21b3 ".join(meaning_wrap))
        print("    \u25ba\u25ba ", end="")
        print("\n    \u21b3 ".join(meaning_en_wrap))
