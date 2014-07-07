#!/usr/bin/env python3
#
# acronym -- Look for acronyms on acronymfinder.com
#
# Dep: local lib: geturl.py
#

import sys
import re
from lib.py import geturl

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
res = geturl.checkresponse(conn, url)
resblock = re.search('ListResults>.*?</table>', res, re.DOTALL)

if resblock:
    rating = re.findall("\*{1,6}", resblock.group())
    meaning = re.findall("- .*?\">", resblock.group())
else:
    ressentence = re.search('- .*?<', res, re.DOTALL).group()

# Remove unnecessary chars
if resblock:
    for k in range(0, len(meaning)):
        meaning[k] = meaning[k].replace('- ', '')
        meaning[k] = meaning[k].replace("\">", '')
else:
    ressentence = ressentence.replace('- ', '')
    ressentence = ressentence.replace('<', '')

# Set the printing to max 10
if resblock:
    if len(rating) > 10:
        anz = 10
    else:
        anz = len(rating)

# Print the result
print("\nThe acronym '%s' could stand for:\n" % (ACRONYM))
if resblock:
    for i in range(0, anz):
        print("%s \t %s" % (rating[i], meaning[i]))
else:
    print("\t"+ressentence)
