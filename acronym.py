#!/usr/bin/env python3
#
# acronym -- Look for acronyms on acronymfinder.com
#
#
#
#
#
#
#
#
#

import sys
import re
from http.client import HTTPConnection

def connecttoaf(body):
    verbindung = HTTPConnection("www.acronymfinder.com")
    verbindung.request("GET", body)

    return verbindung

# Check status code and follow redirections if necessary. Save entry
def checkresponse(connection):
    response = connection.getresponse()

    # Check status for redirection
    if response.status == 301:
        loc = response.getheader('Location')
        connection.close()
        connection = connecttoaf(loc)
        response = connection.getresponse()

    # Check if everything is OK
    if response.status != 200:
        print("Server responded with error code %d." % (response.status))
        sys.exit(1)

    # Save response
    responseentry = response.read().decode('utf-8')
    connection.close()

    return responseentry

# --- Main ---
ACRONYM = sys.argv[1]

# If no acronym is given in the command line; read from stdin.
if len(ACRONYM) == 0:
    for line in sys.stdin:
        ACRONYM += line.split()

# Create search url
search = "/"+ACRONYM+".html"

# Connect to acronymfinder.com and request result.
conn = connecttoaf(search)

# Check, get response and parse the result-table
res = checkresponse(conn)
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
    print(ressentence)
