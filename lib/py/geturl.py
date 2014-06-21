# Needed by acronym.py, leo.py, udict.py

from http.client import HTTPConnection

def connectto(url, body):
    """Connect to url and request a GET with given body.
    Return Connection"""
    verbindung = HTTPConnection(url)
    verbindung.request("GET", body)

    return verbindung

def checkresponse(connection, url):
    """Check given connection if there is a redirect.
    If so: Get Location header and establish a new connection with url and the new body.
    Check if reponse is ok,  decode the response and return it"""
    response = connection.getresponse()

    # Check status for redirection
    if response.status == 301 or response.status == 302:
        loc = response.getheader('Location')
        connection.close()
        connection = connectto(url, loc)
        response = connection.getresponse()

    # Check if everything is OK
    if response.status != 200:
        print("Server responded with error code %d." % (response.status))
        sys.exit(1)

    # Save response. Standard http transfer enc is latin1. So decode is defined
    responseentry = response.read().decode('latin1')
    connection.close()

    return responseentry
