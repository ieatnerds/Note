# Nicholas Kelly


import strutils, osproc, os, times

var message: string
message = ""

type
    argError* = object of Exception

proc head(): void =
    # append date to head of message
    message = getDateStr()
    message.add("-->")
    message.add(getClockStr())
    message.add("\n")

proc isarg(arg: string): bool =
    # Returns true if passed string starts with "-"
    if arg.startsWith("-"):
        return true
    else:
        return false

proc executearg(arg: string): void =
    # executes given argument
    if(toLowerAscii(arg) == "-t"):  # t for Timex
        head()
    else:
        raise newException(argError,"Argument not recognized.")
            
var
    o = open("notes.txt", fmAppend)
let arguments = commandLineParams()

for argument in arguments:
    if(isarg(argument)):
        executearg(argument)

    else:
        message.add(argument)
        message.add(" ")
   
message.add("\n")
message.add("------------------------------")
o.writeLine(message)

o.close()
