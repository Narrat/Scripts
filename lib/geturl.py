# Needed by acronym.py, leo.py, udict.py

import sys
from http.client import HTTPConnection
from http.client import HTTPSConnection

def connectto(url, body):
    """Connect to url and request a GET with given body.
    Return Connection"""
    verbindung = HTTPSConnection(url)
    try:
        verbindung.request("GET", body)
    except:
        print("No SSL. Falling back...")
        verbindung.close()
        verbindung = HTTPConnection(url)
        verbindung.request("GET", body)

    return verbindung

def checkresponse(connection, url):
    """Check given connection if there is a redirect.
    If so: Get Location header and establish a new connection with url and the new body.
    Check if reponse is ok,  decode the response and return it"""
    response = connection.getresponse()
    resp_status = response.status

    # Check status for redirection
    if resp_status == 301 or resp_status == 302:
        loc = response.getheader('Location')
        connection.close()
        connection = connectto(url, loc)
        response = connection.getresponse()
        resp_status = response.status

    # Check if everything is OK
    if resp_status != 200 and resp_status != 404:
        print("Server responded with error code {}.".format(resp_status))
        sys.exit(1)

    # Save response
    responseentry = response.read().decode('utf8')
    connection.close()

    return responseentry, resp_status
