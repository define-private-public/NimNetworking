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
proc downloadWebPage(urlToDownload, filename: string) {.async.} =
  echo("Starting download...")

  # Setup the asynchronous HttpClient
  var httpClient = newAsyncHttpClient()

  # Get the webpage (asynchronously)
  var data:string
  try:
    data = await httpClient.getContent(urlToDownload)
  except HttpRequestError:
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




#proc main()=
#  let
#    urlToDownload = "https://16bpp.net"   # Where to download from
#    filename = "index.html"               # Where to save it to
# 
#  # TODO hold for 5 seconds
#  asyncCheck downloadWebpage(
#
#
#main()
