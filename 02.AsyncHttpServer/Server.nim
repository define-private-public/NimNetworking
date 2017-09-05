# Filename:  Server.nim
# Author:    Benjamin N. Summerton <define-private-public> @def-pri-pub
# License:   Unlicense (http://unlicense.org/)

import asyncDispatch
import asynchttpserver

var
  server = newAsyncHttpServer()
  pageViews = 0
  requestCount = 0


# TODO document
proc mkPage(viewCount: int; disableSubmit: bool): string=
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
    <form method="post" action="shutdown">"
      <input type="submit" value="Shutdown" """ & disableStr & """>
    </form>
  </body>
</html>
  """

echo mkPage(2, true)
#
#proc handleRequest(req: Request) {.async.}=
#  await req.respond(Http200, "Hello World!")
#
#waitFor server.serve(Port(8000), handleRequest)
#
