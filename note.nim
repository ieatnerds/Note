# Nicholas Kelly
# This will create a note based on the command line arguments used
# to run the program. 
#
# this note will have several options to append things such as dates to the
# note. these messages will be written to a file called notes.txt


import strutils, osproc, os, times

var file: File
var message: string
message = ""

type
    argError* = object of Exception

###       ###
### Flags ###
###       ###

proc head(): void =
    # append date to head of message
    message = getDateStr()
    message.add("-->")
    message.add(getClockStr())
    message.add("\n")

proc diag(): void =
    # this function will add all other flags to 
    # the message for testing purposes.
    head()

proc fiop(): void =
    # This is the flag operation for specifying a file
    echo ""  # So it compiles

###            ###
### Procedures ###
###            ###
 
proc isArg(arg: string): bool =
    # Returns true if passed string starts with "-"
    if arg.startsWith("-"):
        return true
    else:
        return false

proc executeArg(arg: string): void =
    # executes given argument
    if(toLowerAscii(arg) == "-t"):  # t for Time
        head()
    if(tolowerAscii(arg) == "-d"):  # d for diagnostics
        diag()
    else:
        raise newException(argError,"Argument not recognized.")

proc noteFile(filename = "notes.txt"): File =
    # Used to specify the file to save notes into
    var o = open(filename, fmAppend)
    return o

###      ###
### Main ###
###      ###
file = noteFile()
let arguments = commandLineParams()

for argument in arguments:
    if(isArg(argument)):
        executeArg(argument)

    else:
        message.add(argument)
        message.add(" ")
   
message.add("\n")
message.add("------------------------------")
file.writeLine(message)

file.close()
