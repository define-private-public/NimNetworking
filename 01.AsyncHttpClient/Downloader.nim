# Filename:  Downloader.nim
# Author:    Benjamin N. Summerton <define-private-public> @def-pri-pub
# License:   Unlicense (http://unlicense.org/)

import os
import httpclient
import asyncDispatch
import asyncfile


## Downloads a webpage asynchronously and saves it to disk.
##   urlToDownload -- Which URL it should download
##   filname -- name/path to save the data to
##
## NOTE: to use HTTPS, you'll need to add `-d:ssl` to the copmpiler flags
proc downloadWebPage(urlToDownload, filename: string) {.async.} =
  echo("Starting download...")

  # Setup the asynchronous HttpClient
  var httpClient = newAsyncHttpClient()

  # Get the webpage (asynchronously)
  var data:string
  try:
    data = await httpClient.getContent(urlToDownload)
  except:
    # Bad thing happened
    let eMsg = getCurrentExceptionMsg()
    echo("Couldn't download the webpage, reason=" & eMsg)
    return 

  # Else, must be a 200 response.  Save it!
  echo("Got it...")
  var f = openAsync(filename, fmWrite)
  await f.write(data)
  f.close()
  echo("Done!")


# Main runner
proc main() {.async.} =
  # Try to download for 5 seconds 
  var dlTask = downloadWebpage("http://unlicense.org/", "index.html")
  echo("Holding for at least 5 seconds")
  discard await withTimeout(dlTask, 5000)


# Hold until `main()` is done
waitFor main()
