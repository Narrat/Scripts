#!/usr/bin/env python3
#
# udict -- Look something up on
# urbandictionary.com
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
    verbindung = HTTPConnection("www.urbandictionary.com")
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

# --- Main ---
INPUT = sys.argv[1:]

# If nothing is given in the command line; read from stdin.
if len(INPUT)==0:
    for line in sys.stdin:
        INPUT += line.split()

# Convert list to str
# and if more than one word is given
# they're joined with a +
INPUT = '+'.join(INPUT)

# Create search url
search = "/define.php?term="+INPUT

# Connect to page and request result.
conn = connecttoud(search)

# Check, get and parse the result
meaning = re.findall("meaning'>\n.*?<div class='example", checkresponse(conn), re.DOTALL)

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
    anz=10
else:
    anz=len(meaning)

# Print the result
print("\n'%s' is used as followed:\n" % (INPUT.replace('+', ' ')))
for i in range(0, anz):
    print("%d:  %s\n" % (i+1, meaning[i]))
