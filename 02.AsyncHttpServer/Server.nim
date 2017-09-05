# Filename:  Server.nim
# Author:    Benjamin N. Summerton <define-private-public> @def-pri-pub
# License:   Unlicense (http://unlicense.org/)
#
# TODO mention strfmt in the tutorial page

import asyncDispatch
import asynchttpserver


# Create the server object and state data
var
  server = newAsyncHttpServer()
  pageViews = 0
  requestCount = 0
let port = 8000


proc mkPage(viewCount: int; disableSubmit: bool): string=
  ## Creates a page for us to display.  In goes a view count and a toggle button
  ## to disable the server, and out comes HTML
  let disableStr = if disableSubmit: "disabled"
                   else:             ""
  return """
<!DOCTYPE>
<html>
  <head>
    <title>HttpListener Example</title>
  </head>
  <body>
    <p>Page Views:""" & $viewCount & """</p>
    <form method="post" action="shutdown">
      <input type="submit" value="Shutdown" """ & disableStr & """>
    </form>
  </body>
</html>
  """


proc handleRequest(req: Request) {.async.}=
  ## Handle an incomming connection
  var killServer = false

  # Incoming!  print some data
  requestCount += 1
  echo("Request #: " & $requestCount)
  echo(req.url.path)
  echo(req.reqMethod)
  echo(req.hostname)
  echo(req.headers["User-Agent"])
  echo("")

  # If the `shutdown` url was requested w/ a POST method, then shutdown the server after serving the page
  if (req.reqMethod == HttpPost) and (req.url.path == "/shutdown"):
    echo("Shutdown requested")
    killServer = true

  # Increment the view counter (if a browser doesn't request `favicon.ico`)
  if req.url.path != "/favicon.ico":
    pageViews += 1

  # Kill the server?
  if killServer:
    server.close()

  # Write a response
  var headers = newHttpHeaders()
  headers.add("Content-Type", "text/html")
  await req.respond(Http200, mkPage(pageViews, killServer), headers)


# Handle requests
echo("Listening for connections on http://localhost:" & $port & "/")
waitFor server.serve(Port(port), handleRequest)

