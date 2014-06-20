# Various functions
# connectto: Establish a connection and send body
# checkresponse: Check response status, follow a redirect if necessary and save the response

from http.client import HTTPConnection

def connectto(url, body):
    verbindung = HTTPConnection(url)
    verbindung.request("GET", body)

    return verbindung

# Check status code and follow redirections if necessary. Save entry
def checkresponse(connection, url):
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
