# logging utility for note.nim

import logging

include util

var fileLoc: string = dirLoc&"info.log"
  
var log = newFileLogger(fileLoc, fmtStr = verboseFmtStr)

addHandler(log)
