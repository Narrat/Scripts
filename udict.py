#!/usr/bin/env python3
#
# udict -- Look something up on
# urbandictionary.com
#
# Dep: local lib: geturl.py
#

import sys
import re
from shutil import get_terminal_size
from textwrap import wrap
from lib import geturl

# If nothing is given in the command line; exit
if len(sys.argv) < 2:
    print("Usage: udict WORD")
    sys.exit(1)

INPUT = sys.argv[1:]

# list to str and if more than one word is given they're joined with a +
INPUT = '+'.join(INPUT)

# Create search url
search = "/define.php?term="+INPUT

# Connect to page and request result.
url = "www.urbandictionary.com"
conn = geturl.connectto(url, search)

# Check, get and parse the result
res, status = geturl.checkresponse(conn, url)
meaning = re.findall("meaning'>\n.*?<div class='example", res, re.DOTALL)

# Remove unnecessary chars
for k in range(0, len(meaning)):
    meaning[k] = meaning[k].lstrip("meaning'>\n")
    meaning[k] = meaning[k].rstrip('</div>\n<div class=\'example')
    meaning[k] = meaning[k].replace('<br/>', '\n    ')
    meaning[k] = meaning[k].replace("<a href=\"/define.php?term=", '(UD: ')
    meaning[k] = meaning[k].replace("\">", ' ) ')
    meaning[k] = meaning[k].replace("</a>", '')
    meaning[k] = meaning[k].replace("\r", '')
    meaning[k] = meaning[k].replace("&#39;", "'")   # latin-1 ' into utf-8 '
    meaning[k] = meaning[k].replace("&quot;", "\"") # latin-1 " into utf-8 "
    meaning[k] = meaning[k].replace("&amp;", "&")   # latin-1 & into utf-8 &

# Set the printing to max 10
anz = 10 if len(meaning) > 10 else len(meaning)

# Print the result
term_col = get_terminal_size().columns
print("\n'{}' is used as followed:\n".format(INPUT.replace('+', ' ')))
for i in range(0, anz):
    sentence = "{0:2d}: {1}\n".format(i+1, meaning[i])
    sentencewrap = wrap(sentence, width=term_col-10, replace_whitespace=False)
    print("\n  \u21b3 ".join(sentencewrap))
