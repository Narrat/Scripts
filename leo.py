#!/usr/bin/env python3
#
# leo -- Look something up on
# leo.org
#
# Dep: local lib: geturl.py
#

import sys
import re
from lib.py import geturl

# Remove unnecessary chars
def removechars(liste):
    for k in range(0, len(liste)):
        liste[k] = liste[k].replace("lang=\"de\">", '')
        liste[k] = liste[k].replace("lang=\"en\">", '')
        liste[k] = liste[k].replace("<small><i>", '')
        liste[k] = liste[k].replace("</i></small>", '')
        liste[k] = liste[k].replace("\n</td>", '')
        liste[k] = liste[k].replace("</td>", '')
        liste[k] = liste[k].replace("<b>", '')
        liste[k] = liste[k].replace("</b>", '')
        liste[k] = liste[k].replace("\n", '')

    return liste

# --- Main ---
INPUT = sys.argv[1:]

# If nothing is given in the command line; read from stdin.
if len(INPUT) == 0:
    for line in sys.stdin:
        INPUT += line.split()

# Convert list to str
# and if more than one word is given
# they're joined with a +
INPUT = '+'.join(INPUT)

# Create search url (ende)
search = "/dictQuery/m-vocab/ende/de.html?searchLoc=0&lp=ende&lang=de&directN=0&search="+INPUT+"&resultOrder=basic&multiwordShowSingle=on"

# Connect to page and request result.
url = "dict.leo.org"
conn = geturl.connectto(url, search)

# Check, get result and parse it
resblock = re.search("tbody>.*</tbody", geturl.checkresponse(conn, url), re.DOTALL)

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
print("\n'%s' could stand for the following:\n\n   en\t|\tde" % (INPUT.replace('+', ' ')))
for i in range(0, anz):
    print("%d: %s\t|\t%s\n" % (i+1, meaning_en[i], meaning[i]))
