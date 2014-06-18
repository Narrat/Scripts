#!/usr/bin/env python3
#
# leo -- Look something up on
# leo.org
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

def connecttoud(body):
    verbindung = HTTPConnection("dict.leo.org")
    verbindung.request("GET", body)

    return verbindung

# Check status code and follow redirections if necessary. Save entry
def checkresponse(connection):
    response = connection.getresponse()

    # Check status for redirection
    if response.status == 302:
        loc = response.getheader('Location')
        connection.close()
        connection = connecttoud(loc)
        response = connection.getresponse()

    # Check if everything is OK
    if response.status != 200:
        print("Server responded with error code %d." % (response.status))
        sys.exit(1)

    # Save response
    responseentry = response.read().decode('utf-8')
    connection.close()

    return responseentry

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
conn = connecttoud(search)

# Check, get result and parse it
resblock = re.search("tbody>.*</tbody", checkresponse(conn), re.DOTALL)

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
