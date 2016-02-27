#!/usr/bin/env python3
#
# acronym -- Look for acronyms on acronymfinder.com
#
# Dep: local lib: geturl.py
#

import sys
import re
from shutil import get_terminal_size
from textwrap import wrap
from lib import geturl
from html import unescape


def removechars(liste):
    """Remove unnecessary chars"""
    for k in range(0, len(liste)):
        liste[k] = liste[k].replace('s=r', '')
        liste[k] = liste[k].replace('- ', '')
        liste[k] = liste[k].replace("\">", '')
        liste[k] = liste[k].replace('<', '')

    return liste

# If no acronym is given in the command line; exit
if len(sys.argv) < 2:
    print("Usage: acronym ACRONYM")
    sys.exit(1)

ACRONYM = sys.argv[1]

# Create search url
search = "/"+ACRONYM+".html"

# Connect to acronymfinder.com and request result.
url = "www.acronymfinder.com"
conn = geturl.connectto(url, search)

# Check, get response and parse the result-table
res, status = geturl.checkresponse(conn, url)
resblock = re.search("search-sort\">.*?</table>", res, re.DOTALL)

if resblock:
    rating = re.findall("s=r[0-5]", resblock.group())
    meaning = re.findall("- .*?\">", resblock.group())
else:
    ressentence = [re.search('- .*?<', res, re.DOTALL).group(), ]

# Remove unnecessary chars
if resblock:
    rating = removechars(rating)
    meaning = removechars(meaning)
    for item in range(0, len(meaning)):
        meaning[item] = unescape(meaning[item])
else:
    ressentence = unescape(ressentence)

# Set the printing to max 10
if resblock:
    anz = 10 if len(rating) > 10 else len(rating)

# Get terminal column size for wrapping text
term_col = get_terminal_size().columns

# Print the result
print("\nThe acronym '{}' could stand for:\n".format(ACRONYM))
if resblock:
    for i in range(0, anz):
        sentence = "{0} \t {1}".format('*'*int(rating[i]), meaning[i])
        sentencewrap = wrap(sentence, width=term_col-10)
        print("\n\t \u21b3 ".join(sentencewrap))
else:
    print("\t"+ressentence[0])
