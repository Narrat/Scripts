#!/usr/bin/env python3
#
# udict -- Look something up on
# urbandictionary.com
#

import sys
import re
from lib.py import geturl

INPUT = sys.argv[1:]

# If nothing is given in the command line; read from stdin.
if len(INPUT) == 0:
    for line in sys.stdin:
        INPUT += line.split()

# Convert list to str
# and if more than one word is given
# they're joined with a +
INPUT = '+'.join(INPUT)

# Create search url
search = "/define.php?term="+INPUT

# Connect to page and request result.
url = "www.urbandictionary.com"
conn = geturl.connectto(url, search)

# Check, get and parse the result
meaning = re.findall("meaning'>\n.*?<div class='example", geturl.checkresponse(conn, url), re.DOTALL)

# Remove unnecessary chars
for k in range(0, len(meaning)):
    meaning[k] = meaning[k].lstrip("meaning'>\n")
    meaning[k] = meaning[k].replace('<br/>', '\n    ')
    meaning[k] = meaning[k].rstrip('</div>\n<div class=\'example')
    meaning[k] = meaning[k].replace("<a href=\"/define.php?term=", '(UD: ')
    meaning[k] = meaning[k].replace("\">", ' ) ')
    meaning[k] = meaning[k].replace("</a>", '')
    meaning[k] = meaning[k].replace("\r", '')
    meaning[k] = meaning[k].replace("&#39;", "'")   # latin-1 ' into utf-8 '
    meaning[k] = meaning[k].replace("&quot;", "\"") # latin-1 " into utf-8 "
    meaning[k] = meaning[k].replace("&amp;", "&")   # latin-1 & into utf-8 &
    #meaning[k] = meaning[k].replace(str(re.search("<a href=\".*\">", meaning[k], re.DOTALL)), "")

# Set the printing to max 10
if len(meaning) > 10:
    anz = 10
else:
    anz = len(meaning)

# Print the result
print("\n'%s' is used as followed:\n" % (INPUT.replace('+', ' ')))
for i in range(0, anz):
    print("%d:  %s\n" % (i+1, meaning[i]))
