# Nicholas Kelly


import strutils, osproc, os, times

var message: string
message = ""

type
    mycustomerror* = object of Exception

proc head(): void =
    message = getDateStr()
    message.add("-->")
    message.add(getClockStr())
    message.add("\n")

proc isarg(arg: string): bool =
    if arg.startsWith("-"):
        return true
    else:
        return false

proc executearg(arg: string): void =
    if(toLowerAscii(arg) == "-t"):  # t for Timex
        head()
    else:
        raise newException(mycustomerror,"Argument not recognized.")
            
var
    o = open("notes.txt", fmAppend)
let arguments = commandLineParams()

for argument in arguments:
    if(isarg(argument)):
        executearg(argument)
        # message = message.add(argument&" ")
    else:
        message.add(argument)
        message.add(" ")
   
message.add("\n")
message.add("------------------------------")
o.writeLine(message)

o.close()
